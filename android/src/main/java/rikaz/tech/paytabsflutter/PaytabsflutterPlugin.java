package rikaz.tech.paytabsflutter;

import android.app.Activity;
import android.app.ActivityManager;
import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.os.Build;
import android.os.Handler;

import androidx.annotation.NonNull;

import com.paytabs.paytabs_sdk.payment.ui.activities.PayTabActivity;
import com.paytabs.paytabs_sdk.utils.PaymentParams;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Random;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/**
 * PaytabsflutterPlugin
 */
public class PaytabsflutterPlugin implements FlutterPlugin, MethodCallHandler, ActivityAware, PluginRegistry.ActivityResultListener {
    private final Random random;
    private final Handler handler;
    private Activity activity;
    private Map<Integer, Result> codes = new HashMap<>();
    private boolean running;

    public PaytabsflutterPlugin() {
        this.random = new Random();
        handler = new Handler();
    }

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        final MethodChannel channel = new MethodChannel(flutterPluginBinding.getFlutterEngine().getDartExecutor(), "paytabsflutter");
        channel.setMethodCallHandler(this);
    }

    // This static function is optional and equivalent to onAttachedToEngine. It supports the old
    // pre-Flutter-1.12 Android projects. You are encouraged to continue supporting
    // plugin registration via this function while apps migrate to use the new Android APIs
    // post-flutter-1.12 via https://flutter.dev/go/android-project-migration.
    //
    // It is encouraged to share logic between onAttachedToEngine and registerWith to keep
    // them functionally equivalent. Only one of onAttachedToEngine or registerWith will be called
    // depending on the user's project. onAttachedToEngine or registerWith must both be defined
    // in the same class.
    public static void registerWith(Registrar registrar) {
        final MethodChannel channel = new MethodChannel(registrar.messenger(), "paytabsflutter");
        PaytabsflutterPlugin handler = new PaytabsflutterPlugin();
        channel.setMethodCallHandler(handler);
        registrar.addActivityResultListener(handler);

    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
        if (call.method.equals("openActivity")) {
            if (activity != null) {
                Intent intent = new Intent(activity, PayTabActivity.class);
                intent.putExtra(PaymentParams.MERCHANT_EMAIL, (String) call.argument("merchant_email"));
                intent.putExtra(PaymentParams.SECRET_KEY, (String) call.argument("secret_key"));//Add your Secret Key Here
                if (call.hasArgument("language") && call.argument("language").equals("ar"))
                    intent.putExtra(PaymentParams.LANGUAGE, PaymentParams.ARABIC);
                else
                    intent.putExtra(PaymentParams.LANGUAGE, PaymentParams.ENGLISH);
                intent.putExtra(PaymentParams.TRANSACTION_TITLE, (String) call.argument("transaction_title"));
                intent.putExtra(PaymentParams.AMOUNT, (Double) call.argument("amount"));
                intent.putExtra(PaymentParams.CURRENCY_CODE, (String) call.argument("currency_code"));
                intent.putExtra(PaymentParams.CUSTOMER_PHONE_NUMBER, (String) call.argument("customer_phone_number"));
                intent.putExtra(PaymentParams.CUSTOMER_EMAIL, (String) call.argument("customer_email"));
                intent.putExtra(PaymentParams.ORDER_ID, (String) call.argument("order_id"));
                intent.putExtra(PaymentParams.PRODUCT_NAME, (String) call.argument("product_name"));
                intent.putExtra(PaymentParams.ADDRESS_BILLING, (String) call.argument("billing_address"));
                intent.putExtra(PaymentParams.CITY_BILLING, (String) call.argument("billing_city"));
                intent.putExtra(PaymentParams.STATE_BILLING, (String) call.argument("billing_state"));
                intent.putExtra(PaymentParams.COUNTRY_BILLING, (String) call.argument("billing_country"));
                intent.putExtra(PaymentParams.POSTAL_CODE_BILLING, (String) call.argument("billing_postal_code")); //Put Country Phone code if Postal code not available '00973'
                int requestCode = random.nextInt();
                codes.put(requestCode, result);
                handler.postDelayed(this::run, 1000);
                running = true;
                activity.startActivityForResult(intent, requestCode);
            }
        } else {
            result.notImplemented();
        }
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    }

    @Override
    public void onAttachedToActivity(ActivityPluginBinding binding) {
        this.activity = binding.getActivity();
        binding.addActivityResultListener(this);
    }

    @Override
    public void onDetachedFromActivityForConfigChanges() {
        this.activity = null;
    }

    @Override
    public void onReattachedToActivityForConfigChanges(ActivityPluginBinding binding) {
        this.activity = binding.getActivity();
        binding.addActivityResultListener(this);
    }

    @Override
    public void onDetachedFromActivity() {
        this.activity = null;
    }

    @Override
    public boolean onActivityResult(int requestCode, int resultCode, Intent data) {
        if (codes.containsKey(requestCode)) {
            if (resultCode == 0) {
                Result r = codes.get(requestCode);
                r.success(new HashMap<String, String>());
                codes.remove(requestCode);
                return true;
            }
            Map<String, String> map = new HashMap<>();
            for (String key : data.getExtras().keySet()) {
                map.put(key, data.getExtras().get(key).toString());
            }
            Result r = codes.get(requestCode);
            r.success(map);
            codes.remove(requestCode);
            return true;
        }
        return false;
    }

    private void run() {
        running = false;
        if (codes.size() == 0)
            return;
        ComponentName cn = getTopActivity();
        if (cn == null)
            return;
        if (!cn.getClassName().equals("com.paytabs.paytabs_sdk.payment.ui.activities.PayTabActivity")
                && !cn.getClassName().equals("com.paytabs.paytabs_sdk.payment.ui.activities.SecurePaymentActivity")
        ) {
            // delay because it's maybe already at main activity and activity result not delivered yet for some reason!
            handler.postDelayed(() -> {
                for (Map.Entry<Integer, Result> entry : codes.entrySet()) {
                    Result result = entry.getValue();
                    result.error("TIMEOUT", "paytabs exited from activity without calling onActivityResult", null);
                }
                codes.clear();
            }, 1000);
        } else {
            handler.postDelayed(this::run, 1000);
        }
    }

    private ComponentName getTopActivity() {
        ActivityManager am = (ActivityManager) activity.getSystemService(Context.ACTIVITY_SERVICE);
        ComponentName cn = null;
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            cn = am.getAppTasks().get(0).getTaskInfo().topActivity;
        } else {
            List<ActivityManager.RunningTaskInfo> runningTasks = am.getRunningTasks(10);
            for (ActivityManager.RunningTaskInfo info : runningTasks) {
                if (info.topActivity.getPackageName().equals(activity.getPackageName())) {
                    cn = info.topActivity;
                }
            }

        }
        return cn;
    }
}
