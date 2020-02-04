class MyOrderProductListModel {
  var orderNumber;
  var orderTotal;
  var orderItemStatus;

  var orderPaymentMethod;
  var orderPaymentStatus;

  var orderShippingMethod;
  var orderShippingStatus;

  var orderItemDate;
  var orderItemQuantity;
  var orderSubTotal;
  var orderShipping;
  var orderCurrency;
  var orderTax;
  var orderEarnPoints;
  var orderSubTotalDiscount;
  var orderOrderTotalDiscount;
  var orderOrderPdfInvoiceDownloadUrl;

  List<MyOrderProductListModel> orderItemProductList;
  MyOrderProductListModel billingAddressMap;
  MyOrderProductListModel shippingAddressMap;

  MyOrderProductListModel.fromMapForMyOrderProductList(
      Map<String, dynamic> map) {
    if (checkForNull("id", map)) {
      orderNumber = map['id'];
    }
    if (checkForNull("order_status", map)) {
      orderItemStatus = map['order_status'];
    }
    if (checkForNull("pdfinvoicelink", map)) {
      orderOrderPdfInvoiceDownloadUrl = map['pdfinvoicelink'];
    }

    if (checkForNull("shipping_method", map)) {
      orderShippingMethod = map['shipping_method'];
    }

    if (checkForNull("shipping_status", map)) {
      orderShippingStatus = map['shipping_status'];
    }

    if (checkForNull("payment_method_system_name", map)) {
      orderPaymentMethod = map['payment_method_system_name'];
    }

    if (checkForNull("payment_status", map)) {
      orderPaymentStatus = map['payment_status'];
    }

    if (checkForNull("order_total", map)) {
      orderTotal = map['order_total'];
    }

    if (checkForNull("created_on_utc", map)) {
      orderItemDate = map['created_on_utc'];
    }

    if (checkForNull("order_subtotal_incl_tax", map)) {
      orderSubTotal = map['order_subtotal_incl_tax'];
    }

    if (checkForNull("order_shipping_incl_tax", map)) {
      orderShipping = map['order_shipping_incl_tax'];
    }
    if (checkForNull("order_tax", map)) {
      orderTax = map['order_tax'];
    }
    if (checkForNull("order_sub_total_discount_incl_tax", map)) {
      orderSubTotalDiscount = map['order_sub_total_discount_incl_tax'];
    }
    if (checkForNull("order_discount", map)) {
      orderOrderTotalDiscount = map['order_discount'];
    }

    if (checkForNull("billing_address", map)) {
      Map billingAddress = map['billing_address'];
      if (billingAddress != null) {
        billingAddressMap =
            new MyOrderProductListModel.fromMapForBillingAddress(
                billingAddress);
      }
    }

    if (checkForNull("shipping_address", map)) {
      Map shippingAddress = map['shipping_address'];
      if (shippingAddress != null) {
        shippingAddressMap =
            new MyOrderProductListModel.fromMapForShippingAddress(
                shippingAddress);
      }
    }

    if (checkForNull("order_items", map)) {
      List orderProductList = map['order_items'];
      orderItemProductList = orderProductList
          .map((c) => new MyOrderProductListModel.fromMapForOrderProductList(c))
          .toList();
    }
  }

  var orderItemId;
  var orderItemName;
  var orderItemImage;

  var orderItemPrice;
  var orderItemOldPrice;
  var orderItemRating;
  var orderItemSku;

  MyOrderProductListModel.fromMapForOrderProductList(Map<String, dynamic> map) {
    if (checkForNull("id", map)) {
      orderItemId = map['id'];
    }

    if (checkForNull("quantity", map)) {
      orderItemQuantity = map['quantity'];
    }
   /* if (checkForNull("order_items", map)) {
      List orderitems = map['order_items'];
      if (orderitems.length != 0) {
        orderCurrency = orderitems[0]["product"]["CurrencyType"];
      }
    }*/

    if (checkForNull("product", map)) {
      Map productDetail = map['product'];

      if (checkForNull("name", productDetail)) {
        orderItemName = productDetail['name'];
      }

      if (checkForNull("CurrencyType", productDetail)) {
        orderCurrency = productDetail['CurrencyType'];
      }

      if (checkForNull("sku", productDetail)) {
        orderItemSku = productDetail['sku'];
      }

      if (checkForNull("images", productDetail)) {
        List list = productDetail['images'];
        if (list.length != 0) {
          List images = productDetail["images"];
          if (checkForNull("src", images[0])) {
            if (images.length!=null && images.length > 0) {
              orderItemImage = images[0]['src'];
            }
          }
        }
      }

      if (checkForNull("price", productDetail)) {
        orderItemPrice = productDetail['price'];
      }

      if (checkForNull("old_price", productDetail)) {
        orderItemOldPrice = productDetail['old_price'];
      }

      if (checkForNull("approved_rating_sum", productDetail)) {
        orderItemRating = productDetail['approved_rating_sum'];
      }
    }

  }

  var customerId;
  var customerFirstName;
  var customerLastName;
  var customerEmail;
  var customerPhone;
  var customerFax;
  var customerCompany;
  var customerAddress1;
  var customerAddress2;
  var customerCity;
  var customerCountry;
  var customerProvince;
  var customerZipCode;

  MyOrderProductListModel.fromMapForBillingAddress(Map<String, dynamic> map) {
    if (checkForNull("id", map)) {
      customerId = map['id'];
    }
    if (checkForNull("first_name", map)) {
      customerFirstName = map['first_name'];
    }
    if (checkForNull("last_name", map)) {
      customerLastName = map['last_name'];
    }
    if (checkForNull("email", map)) {
      customerEmail = map['email'];
    }
    if (checkForNull("phone_number", map)) {
      customerPhone = map['phone_number'];
    }
    if (checkForNull("fax_number", map)) {
      customerFax = map['fax_number'];
    }
    if (checkForNull("company", map)) {
      customerCompany = map['company'];
    }
    if (checkForNull("country", map)) {
      customerCountry = map['country'];
    }
    if (checkForNull("address1", map)) {
      customerAddress1 = map['address1'];
    }
    if (checkForNull("address2", map)) {
      customerAddress2 = map['address2'];
    }
    if (checkForNull("city", map)) {
      customerCity = map['city'];
    }
    if (checkForNull("province", map)) {
      customerProvince = map['province'];
    }
    if (checkForNull("zip_postal_code", map)) {
      customerZipCode = map['zip_postal_code'];
    }
  }

  MyOrderProductListModel.fromMapForShippingAddress(Map<String, dynamic> map) {
    if (checkForNull("id", map)) {
      customerId = map['id'];
    }
    if (checkForNull("first_name", map)) {
      customerFirstName = map['first_name'];
    }
    if (checkForNull("last_name", map)) {
      customerLastName = map['last_name'];
    }
    if (checkForNull("email", map)) {
      customerEmail = map['email'];
    }
    if (checkForNull("phone_number", map)) {
      customerPhone = map['phone_number'];
    }
    if (checkForNull("fax_number", map)) {
      customerFax = map['fax_number'];
    }
    if (checkForNull("company", map)) {
      customerCompany = map['company'];
    }
    if (checkForNull("country", map)) {
      customerCountry = map['country'];
    }
    if (checkForNull("address1", map)) {
      customerAddress1 = map['address1'];
    }
    if (checkForNull("address2", map)) {
      customerAddress2 = map['address2'];
    }
    if (checkForNull("city", map)) {
      customerCity = map['city'];
    }
    if (checkForNull("province", map)) {
      customerProvince = map['province'];
    }
    if (checkForNull("zip_postal_code", map)) {
      customerZipCode = map['zip_postal_code'];
    }
  }

  bool checkForNull(String key, Map<String, dynamic> map) {
    return map.containsKey(key) && map[key] != null;
  }
}
