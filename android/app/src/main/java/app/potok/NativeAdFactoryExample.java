package app.potok;

import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.TextView;

import com.google.android.gms.ads.formats.MediaView;
import com.google.android.gms.ads.formats.UnifiedNativeAd;
import com.google.android.gms.ads.formats.UnifiedNativeAdView;

import java.util.Map;


import io.flutter.plugins.googlemobileads.GoogleMobileAdsPlugin.NativeAdFactory;


class NativeAdFactoryExample implements NativeAdFactory {
    private final LayoutInflater layoutInflater;

    NativeAdFactoryExample(LayoutInflater layoutInflater) {
        this.layoutInflater = layoutInflater;
    }

    @Override
    public UnifiedNativeAdView createNativeAd(
            UnifiedNativeAd nativeAd, Map<String, Object> customOptions) {
        final UnifiedNativeAdView adView =
                (UnifiedNativeAdView) layoutInflater.inflate(R.layout.my_native_ad, null);
        final TextView headlineView = adView.findViewById(R.id.ad_headline);
        final TextView bodyView = adView.findViewById(R.id.ad_body);
        final MediaView mediaView = adView.findViewById(R.id.ad_media);
        final Button button = adView.findViewById(R.id.ad_call_to_action);
        final ImageView icon = adView.findViewById(R.id.ad_app_icon);

        button.setText(nativeAd.getCallToAction());

        mediaView.setOnHierarchyChangeListener(new ViewGroup.OnHierarchyChangeListener() {
            @Override
            public void onChildViewAdded(View parent, View child) {
                if (child instanceof ImageView) {
                    ImageView imageView = (ImageView) child;
                    imageView.setAdjustViewBounds(true);
                }
            }

            @Override
            public void onChildViewRemoved(View parent, View child) {
            }
        });

        headlineView.setText(nativeAd.getHeadline());
        bodyView.setText(nativeAd.getBody());

        adView.setBackgroundColor(0xFFFFFF);

        adView.setIconView(icon);
        adView.setCallToActionView(button);
        adView.setMediaView(mediaView);
        adView.setNativeAd(nativeAd);
        adView.setBodyView(bodyView);
        adView.setHeadlineView(headlineView);
        return adView;
    }
}