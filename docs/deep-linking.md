# Product deep links

Android product links use the `humavolve` custom URL scheme:

```text
humavolve://app/products/396
humavolve://app/products/396?categoryId=3&source=share
```

The product ID is a required positive integer route parameter. `categoryId` is
an optional positive integer query parameter and, when supplied, must match the
product's category. Other query parameters are accepted. Opening a product
fetches it from the existing product API, so the link works without first
loading the home screen. Unrecognized routes and unavailable products show
fallback screens.

## Android setup

The app declares a browsable intent filter for `humavolve://app/...`. No domain
ownership or Digital Asset Links file is required for this custom scheme.
Because custom schemes are not domain-verified, another installed app could
claim the same scheme.

There is no `ios/` project in this repository. To support iOS, add the URL
scheme to the iOS Runner target's URL Types (or `CFBundleURLTypes` in
`Info.plist`) and verify Flutter's incoming-link configuration for that target.

## Test on an Android emulator/device

Install and start the app once, then use the application ID from
`android/app/build.gradle.kts`:

```powershell
adb shell am force-stop com.example.ecommerce_app_huma_volve
adb shell am start -a android.intent.action.VIEW -c android.intent.category.BROWSABLE -d "humavolve://app/products/396?categoryId=3&source=test" com.example.ecommerce_app_huma_volve
```

The example ID is from the configured API at the time this document was
written. Replace it with an available product ID, and use its actual category
ID when including `categoryId`. The same `am start` command
tests links received while the app is backgrounded or foregrounded; omit the
`force-stop` line for those cases. Try `humavolve://app/products/not-a-number`
and `humavolve://app/unknown` to verify invalid and unknown route fallbacks.
