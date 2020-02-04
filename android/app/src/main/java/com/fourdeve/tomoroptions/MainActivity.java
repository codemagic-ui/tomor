package com.fourdeve.tomoroptions;

import android.content.Intent;
import android.os.Bundle;
import androidx.annotation.Nullable;
import android.text.Html;
import android.util.Log;
import android.widget.Toast;


import org.json.JSONException;
import org.json.JSONObject;

import java.util.HashMap;
import java.util.List;

import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {


    MethodChannel.Result result;
    MethodCall call;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        GeneratedPluginRegistrant.registerWith(this);


        new MethodChannel(getFlutterView(), "htmlView").setMethodCallHandler(
                new MethodChannel.MethodCallHandler() {
                    @Override
                    public void onMethodCall(MethodCall call, MethodChannel.Result result) {

                        if (call.method.equals("HtmlToString")) {
                            HashMap<String, Object> hashmap = (HashMap<String, Object>) call.arguments;
                            String mHtmlString = String.valueOf(hashmap.get("t"));
                            String text = String.valueOf(Html.fromHtml(Html.fromHtml(mHtmlString).toString()));
                            String text22 = String.valueOf(Html.fromHtml(Html.fromHtml(text).toString()));
                            result.success(text22);
                        }
                    }
                });
    }

   /* void creditDebitCard() throws Exception {
        HashMap<String, Object> paymentParams = null;
        HashMap<String, Object> cardDetail = null;
        HashMap<String, Object> productDetail = null;
        try {
            List list = (List) call.arguments;
            if (list.size() == 3) {
                cardDetail = (HashMap<String, Object>) list.get(0);
                productDetail = (HashMap<String, Object>) list.get(1);
                paymentParams = (HashMap<String, Object>) list.get(2);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        if (paymentParams != null) {
            setGeneralParams(paymentParams);
        }
        if (cardDetail != null) {
            setParamsForCard(cardDetail);
        }

    }

    void setGeneralParams(HashMap<String, Object> hashMap) {
        if (hashMap.containsKey("merchantKey")) {
            merchantKey = hashMap.get("merchantKey").toString();
        }
        if (hashMap.containsKey("salt")) {
            salt = hashMap.get("salt").toString();
        }
        if (hashMap.containsKey("isInProductionMode")) {
            isInProductionMode = (boolean) hashMap.get("isInProductionMode");
        }
        if (hashMap.containsKey("firstName")) {
            firstName = hashMap.get("firstName").toString();
        }
        if (hashMap.containsKey("email")) {
            email = hashMap.get("email").toString();
        }
        if (hashMap.containsKey("phone")) {
            phone = hashMap.get("phone").toString();
        }
        if (hashMap.containsKey("productInfo")) {
            productInfo = hashMap.get("productInfo").toString();
        }
        if (hashMap.containsKey("amount")) {
            amount = (double) hashMap.get("amount");
        }
        if (hashMap.containsKey("txnId")) {
            txtId = hashMap.get("txnId").toString();
        }
        if (hashMap.containsKey("sUrl")) {
            sUrl = hashMap.get("sUrl").toString();
        }
        if (hashMap.containsKey("fUrl")) {
            fUrl = hashMap.get("fUrl").toString();
        }

        if (hashMap.containsKey("UTF1")) {
            UTF1 = hashMap.get("UTF1").toString();
        }
        if (hashMap.containsKey("UTF2")) {
            UTF2 = hashMap.get("UTF2").toString();
        }
        if (hashMap.containsKey("UTF3")) {
            UTF3 = hashMap.get("UTF3").toString();
        }
        if (hashMap.containsKey("UTF4")) {
            UTF4 = hashMap.get("UTF4").toString();
        }
        if (hashMap.containsKey("UTF5")) {
            UTF5 = hashMap.get("UTF5").toString();
        }


        if (merchantKey != null) {
            paymentParams.setKey(merchantKey); // Get Merchant Key from PayU Biz Merchant Account
        }
        if (firstName != null) {
            paymentParams.setFirstName(firstName); // User Name
        }
        if (email != null) {
            paymentParams.setEmail(email); // User Email Address
        }
        if (phone != null) {
            paymentParams.setPhone(phone); // User Mobile Number
        }
        if (productInfo != null) {
            paymentParams.setProductInfo(productInfo); // Product info
        }

        paymentParams.setAmount(String.valueOf(amount)); // Amout

        if (txtId != null) {
            paymentParams.setTxnId(txtId); // Transaction ID
        }

        if (sUrl != null) {
            paymentParams.setSurl(sUrl);//success Url
        }

        if (fUrl != null) {
            paymentParams.setFurl(fUrl);//success Url
        }

        if (UTF1 != null) {
            paymentParams.setUdf1(UTF1);//success Url
        }
        if (UTF2 != null) {
            paymentParams.setUdf2(UTF2);//success Url
        }
        if (UTF3 != null) {
            paymentParams.setUdf3(UTF3);//success Url
        }
        if (UTF4 != null) {
            paymentParams.setUdf4(UTF4);//success Url
        }
        if (UTF5 != null) {
            paymentParams.setUdf5(UTF5);//success Url
        }

        if (isInProductionMode) {
            payuConfig.setEnvironment(PayuConstants.PRODUCTION_ENV);
        } else {
            payuConfig.setEnvironment(PayuConstants.MOBILE_DEV_ENV);
        }

    }

    void setParamsForCard(HashMap<String, Object> hashMap) throws Exception {
        String cardName = null;
        String cardHolderName = null;
        String cardNumber = null;
        String cardExpireMonth = null;
        String cardExpireYear = null;
        String cardCVV = null;

        if (hashMap.containsKey("cardName")) {
            cardName = hashMap.get("cardName").toString();
        }

        if (hashMap.containsKey("cardHolderName")) {
            cardHolderName = hashMap.get("cardHolderName").toString();
        }

        if (hashMap.containsKey("cardNumber")) {
            cardNumber = hashMap.get("cardNumber").toString();
        }

        if (hashMap.containsKey("cardExpireMonth")) {
            cardExpireMonth = hashMap.get("cardExpireMonth").toString();
        }

        if (hashMap.containsKey("cardExpireYear")) {
            cardExpireYear = hashMap.get("cardExpireYear").toString();
        }

        if (hashMap.containsKey("cardCVV")) {
            cardCVV = hashMap.get("cardCVV").toString();
        }

        if (cardName != null) {
            paymentParams.setCardName(cardName);
        }
        if (cardHolderName != null) {
            paymentParams.setNameOnCard(cardHolderName);
        }

        if (cardNumber != null) {
            paymentParams.setCardNumber(cardNumber);
        }

        if (cardExpireMonth != null) {
            paymentParams.setExpiryMonth(cardExpireMonth);
        }

        if (cardExpireYear != null) {
            paymentParams.setExpiryYear(cardExpireYear);
        }

        if (cardCVV != null) {
            paymentParams.setCvv(cardCVV);
        }
        paymentParams.setEnableOneClickPayment(1);

        PayuHashes payuHashes = generateHashFromSDK(paymentParams, salt);
        paymentParams.setHash(payuHashes.getPaymentHash());

        PostData postData = new PaymentPostParams(paymentParams, PayuConstants.CC).getPaymentPostParams();
        if (postData.getCode() == PayuErrors.NO_ERROR) {
            payuConfig.setData(postData.getResult());
            Intent intent = new Intent(this, PaymentsActivity.class);
            intent.putExtra(PayuConstants.PAYU_CONFIG, payuConfig);
            startActivityForResult(intent, PayuConstants.PAYU_REQUEST_CODE);
        } else {
            Toast.makeText(this, postData.getResult(), Toast.LENGTH_LONG).show();
            result.error(postData.getResult(), String.valueOf(postData.getCode()), postData.getStatus());
        }
    }

    public PayuHashes generateHashFromSDK(PaymentParams mPaymentParams, String salt) {
        PayuHashes payuHashes = new PayuHashes();
        PostData postData = new PostData();

        // payment Hash;
        PayUChecksum checksum = new PayUChecksum();
        checksum.setAmount(mPaymentParams.getAmount());
        checksum.setKey(mPaymentParams.getKey());
        checksum.setTxnid(mPaymentParams.getTxnId());
        checksum.setEmail(mPaymentParams.getEmail());
        checksum.setSalt(salt);
        checksum.setProductinfo(mPaymentParams.getProductInfo());
        checksum.setFirstname(mPaymentParams.getFirstName());
        checksum.setUdf1(mPaymentParams.getUdf1());
        checksum.setUdf2(mPaymentParams.getUdf2());
        checksum.setUdf3(mPaymentParams.getUdf3());
        checksum.setUdf4(mPaymentParams.getUdf4());
        checksum.setUdf5(mPaymentParams.getUdf5());

        postData = checksum.getHash();
        if (postData.getCode() == PayuErrors.NO_ERROR) {
            payuHashes.setPaymentHash(postData.getResult());
        }

        // checksum for payemnt related details
        // var1 should be either user credentials or default
        String var1 = mPaymentParams.getUserCredentials() == null ? PayuConstants.DEFAULT : mPaymentParams.getUserCredentials();
        String key = mPaymentParams.getKey();

        if ((postData = calculateHash(key, PayuConstants.PAYMENT_RELATED_DETAILS_FOR_MOBILE_SDK, var1, salt, checksum)) != null && postData.getCode() == PayuErrors.NO_ERROR) // Assign post data first then check for success
            payuHashes.setPaymentRelatedDetailsForMobileSdkHash(postData.getResult());
        //vas
        if ((postData = calculateHash(key, PayuConstants.VAS_FOR_MOBILE_SDK, PayuConstants.DEFAULT, salt, checksum)) != null && postData.getCode() == PayuErrors.NO_ERROR)
            payuHashes.setVasForMobileSdkHash(postData.getResult());

        // getIbibocodes
        if ((postData = calculateHash(key, PayuConstants.GET_MERCHANT_IBIBO_CODES, PayuConstants.DEFAULT, salt, checksum)) != null && postData.getCode() == PayuErrors.NO_ERROR)
            payuHashes.setMerchantIbiboCodesHash(postData.getResult());

        if (!var1.contentEquals(PayuConstants.DEFAULT)) {
            // get user card
            if ((postData = calculateHash(key, PayuConstants.GET_USER_CARDS, var1, salt, checksum)) != null && postData.getCode() == PayuErrors.NO_ERROR) // todo rename storedc ard
                payuHashes.setStoredCardsHash(postData.getResult());
            // save user card
            if ((postData = calculateHash(key, PayuConstants.SAVE_USER_CARD, var1, salt, checksum)) != null && postData.getCode() == PayuErrors.NO_ERROR)
                payuHashes.setSaveCardHash(postData.getResult());
            // delete user card
            if ((postData = calculateHash(key, PayuConstants.DELETE_USER_CARD, var1, salt, checksum)) != null && postData.getCode() == PayuErrors.NO_ERROR)
                payuHashes.setDeleteCardHash(postData.getResult());
            // edit user card
            if ((postData = calculateHash(key, PayuConstants.EDIT_USER_CARD, var1, salt, checksum)) != null && postData.getCode() == PayuErrors.NO_ERROR)
                payuHashes.setEditCardHash(postData.getResult());
        }

        if (mPaymentParams.getOfferKey() != null) {
            postData = calculateHash(key, PayuConstants.OFFER_KEY, mPaymentParams.getOfferKey(), salt, checksum);
            if (postData.getCode() == PayuErrors.NO_ERROR) {
                payuHashes.setCheckOfferStatusHash(postData.getResult());
            }
        }

        if (mPaymentParams.getOfferKey() != null && (postData = calculateHash(key, PayuConstants.CHECK_OFFER_STATUS, mPaymentParams.getOfferKey(), salt, checksum)) != null && postData.getCode() == PayuErrors.NO_ERROR) {
            payuHashes.setCheckOfferStatusHash(postData.getResult());
        }

        // we have generated all the hases now lest launch sdk's ui
        return payuHashes;
    }

    private PostData calculateHash(String key, String command, String var1, String salt, PayUChecksum checksum) {

        checksum.setKey(key);
        checksum.setCommand(command);
        checksum.setVar1(var1);
        checksum.setSalt(salt);
        return checksum.getHash();
    }
*/
    /*@Override
    protected void onActivityResult(int requestCode, int resultCode, @Nullable Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (requestCode == PayuConstants.PAYU_REQUEST_CODE) {
            switch (resultCode) {
                case RESULT_OK:
                    *//*Toast.makeText(MainActivity.this, "Payment Success.", Toast.LENGTH_SHORT).show();
                    if (data != null) {
                        String merchantResponse = data.getStringExtra("result");
                        String payuResponse = data.getStringExtra("payu_response");

                        try {
                            JSONObject jsonObj = new JSONObject(payuResponse);
                            String response = payuResponse.toString();
                            String id = jsonObj.getString("id");
                            String key = jsonObj.getString("key");
                            String txnId = jsonObj.getString("txnid");
                            String transaction_fee = jsonObj.getString("transaction_fee");
                            String hash = jsonObj.getString("hash");
                            String status = jsonObj.getString("status");
                            String productInfo = jsonObj.getString("productinfo");
                            String amount = jsonObj.getString("amount");
                            String bank_ref_no = jsonObj.getString("bank_ref_no");
                            String payment_source = jsonObj.getString("payment_source");

                            HashMap<String, Object> responseHash = new HashMap<>();
                            responseHash.put("response", response);
                            responseHash.put("id", id);
                            responseHash.put("key", key);
                            responseHash.put("txnId", txnId);
                            responseHash.put("transaction_fee", transaction_fee);
                            responseHash.put("hash", hash);
                            responseHash.put("status", status);
                            responseHash.put("productInfo", productInfo);
                            responseHash.put("amount", amount);
                            responseHash.put("bank_ref_no", bank_ref_no);
                            responseHash.put("payment_source", payment_source);

                            result.success(responseHash);


                        } catch (final JSONException e) {
                            Log.e("Atg", "Json parsing error: " + e.getMessage());
                            runOnUiThread(new Runnable() {
                                @Override
                                public void run() {
                                    Toast.makeText(getApplicationContext(), "Json parsing error: " + e.getMessage(), Toast.LENGTH_LONG).show();
                                }
                            });

                        }
                    }*//*
                    break;
                case RESULT_CANCELED:
                    Toast.makeText(MainActivity.this, "Payment Cancelled | Failed.", Toast.LENGTH_SHORT).show();
                    if (data != null) {
                        String merchantResponse = data.getStringExtra("result");
                        String payuResponse = data.getStringExtra("payu_response");
                        Log.i("Response", "onActivityResult: result - " + merchantResponse);
                        Log.i("Response", "onActivityResult: payu_response - " + payuResponse);

                    }
                    break;
            }

        }
    }*/


}
