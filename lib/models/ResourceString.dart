import 'package:i_am_a_student/utils/LanguageStrings.dart';

class ResourceString {
  String languageId;
  String name;
  bool rtl;
  String resourceName;
  String resourceValue;
  String id;

  ResourceString(
      {this.languageId,
      this.name,
      this.rtl,
      this.resourceName,
      this.resourceValue,
      this.id});

  ResourceString.fromMap(Map<String, dynamic> map) {
    if (checkForNull(map, "LanguageId")) {
      languageId = map["LanguageId"].toString();
    }
    if (checkForNull(map, "ResourceName")) {
      resourceName = map["ResourceName"].toString();
    }

    if (checkForNull(map, "ResourceValue")) {
      resourceValue = map["ResourceValue"].toString();
    }
  }

  @override
  String toString() {
    return 'ResourceString{languageId: $languageId, name: $name, rtl: $rtl, resourceName: $resourceName, resourceValue: $resourceValue, id: $id}';
  }

  static Future setIntoLanguageString(List<ResourceString> list) {
    for (int i = 0; i < list.length; i++) {
      ResourceString value = list[i];
      print(value.toString());
      if (value != null && value.resourceValue != null) {
        switch (value.resourceName) {
          case "Account.Login.Welcome":
            LanguageStrings.welcomeLabel = value.resourceValue;
            break;
          case "Account.Login.Fields.Email":
            LanguageStrings.emailTextFiled = value.resourceValue;
            break;
          case "Account.Login.Fields.Password":
            LanguageStrings.passwordTextFiled = value.resourceValue;
            break;
          case "Account.Login.ForgotPassword":
            LanguageStrings.forgetPasswordLabel = value.resourceValue;
            break;
          case "Account.Login.Fields.Email.Required":
            LanguageStrings.emailErrorText = value.resourceValue;
            break;
          case "Admin.Common.WrongEmail":
            LanguageStrings.emailValidText = value.resourceValue;
            break;
          case "Account.Login.LoginButton":
            LanguageStrings.singInButtonLabel = value.resourceValue;
            break;
          case "PageTitle.Register":
            LanguageStrings.signUpTitle = value.resourceValue;
            LanguageStrings.signUpButtonLabelRegistration = value.resourceValue;
            break;
          case "Account.Fields.FirstName":
            LanguageStrings.firstNameTextFiled = value.resourceValue;
            break;
          case "Account.Fields.FirstName.Required":
            LanguageStrings.firstNameErrortext = value.resourceValue;
            break;
          case "Account.Fields.LastName":
            LanguageStrings.lastNameTextFiled = value.resourceValue;
            break;
          case "Account.Fields.LastName.Required":
            LanguageStrings.lastNameErrortext = value.resourceValue;
            break;
          case "Account.Fields.Email":
            LanguageStrings.emailTextFiledSignUp = value.resourceValue;
            break;
          case "Account.Fields.Email.Required":
            LanguageStrings.emailErrorTextSignUp = value.resourceValue;
            break;
          case "Account.Fields.Company":
            LanguageStrings.companyTextFiled = value.resourceValue;
            break;
          case "Account.Fields.Company.Required":
            LanguageStrings.companyErrorText = value.resourceValue;
            break;
          case "Account.Fields.DateOfBirth":
            LanguageStrings.birthDateTextFiled = value.resourceValue;
            break;
          case "Account.Fields.Password":
            LanguageStrings.passwordTextFiledSignUp = value.resourceValue;
            break;
          case "Account.PasswordRecovery.ConfirmNewPassword.Required":
            LanguageStrings.passwordErrorTextSignUp = value.resourceValue;
            break;
          case "Account.Fields.ConfirmPassword":
            LanguageStrings.confirmPasswordTextFiled = value.resourceValue;
            break;
          case "Account.Fields.ConfirmPassword.Required":
            LanguageStrings.confirmPasswordErrorText = value.resourceValue;
            break;
          case "Account.Fields.Newsletter":
            LanguageStrings.newsLetterLabel = value.resourceValue;
            break;
          case "Account.Fields.Gender.Male":
            LanguageStrings.maleLabelSignUp = value.resourceValue;
            break;
          case "Account.Fields.Gender.Female":
            LanguageStrings.feMaleLabelSignUp = value.resourceValue;
            break;
          case "Account.Fields.Password.EnteredPasswordsDoNotMatch":
            LanguageStrings.passwordMatchToast = value.resourceValue;
            break;
          case "Admin.Common.WrongEmail":
            LanguageStrings.emailValidTextSignUp = value.resourceValue;
            break;
          case "Account.Fields.Gender":
            LanguageStrings.genderLabel = value.resourceValue;
            break;
          case "Account.PasswordRecovery":
            LanguageStrings.strForgotScreenPassword = value.resourceValue;
            break;
          case "Account.PasswordRecovery.Tooltip":
            LanguageStrings.strForgotPasswordScreenSubTitle =
                value.resourceValue;
            break;
          case "Products.EmailAFriend.YourEmailAddress":
            LanguageStrings.strHintEmailOrPhone = value.resourceValue;
            break;
          case "Admin.Common.WrongEmail":
            LanguageStrings.strErrorInvalidEmailOrPhone = value.resourceValue;
            break;
          case "Products.EmailAFriend.YourEmailAddress.Hint":
            LanguageStrings.strErrorEmptyEmailOrPhone = value.resourceValue;
            break;
          case "Account.PasswordRecovery.RecoverButton":
            LanguageStrings.strBtnContinue = value.resourceValue;
            break;
          case "Admin.Home":
            LanguageStrings.homeLabel = value.resourceValue;
            break;
          case "PageTitle.Account":
            LanguageStrings.accountLabel1 = value.resourceValue;
            break;
          case "Homepage.Products":
            LanguageStrings.featuredLabel = value.resourceValue;
            break;
          case "Admin.ContentManagement.News":
            LanguageStrings.newsLetterLabelHome = value.resourceValue;
            break;
          case "Manufacturers.ViewAll":
            LanguageStrings.viewLabel = value.resourceValue;
            break;
          case "Reviews.Fields.Rating.Excellent":
            LanguageStrings.excellentToast = value.resourceValue;
            break;
          case "Reviews.Fields.Rating.Good":
            LanguageStrings.goodToast = value.resourceValue;
            break;
          case "Reviews.Fields.Rating.Bad":
            LanguageStrings.poorToast = value.resourceValue;
            break;
          case "nop.MyAccountScreen.title":
            LanguageStrings.titleMyAccount = value.resourceValue;
            break;
          case "Admin.Customers.Customers.Orders":
            LanguageStrings.ordersLabel = value.resourceValue;
            break;
          case "Account.RewardPoints":
            LanguageStrings.rewardPointLabel = value.resourceValue;
            break;
          case "nop.MyAccountScreen.title.wishList":
            LanguageStrings.wishListLabel = value.resourceValue;
            break;
          case "Admin.Orders.Products.Download":
            LanguageStrings.downloadableLabel = value.resourceValue;
            break;
          case "PageTitle.CustomerProductReviews":
            LanguageStrings.reviewLabel = value.resourceValue;
            break;
          case "PageTitle.CustomerProductReviews":
            LanguageStrings.addressLabel = value.resourceValue;
            break;
          case "Admin.Configuration.EmailAccounts.Fields.Password.Change":
            LanguageStrings.passwordLabel = value.resourceValue;
            break;
          case "nop.MyAccountScreen.title.myAccount.language":
            LanguageStrings.languageLable = value.resourceValue;
            break;
          case "nop.MyAccountScreen.title.myAccount.quickLinks":
            LanguageStrings.quickLinks = value.resourceValue;
            break;
          case "Admin.Help":
            LanguageStrings.helpLabel = value.resourceValue;
            break;
          case "nop.MyAccountScreen.title.rateUs":
            LanguageStrings.rateLabel = value.resourceValue;
            break;
          case "nop.MyAccountScreen.title.aboutUs":
            LanguageStrings.aboutLabel = value.resourceValue;
            break;
          case "ContactUs":
            LanguageStrings.contactLabel = value.resourceValue;
            break;
          case "nop.MyAccountScreen.title.tearmAndConditions":
            LanguageStrings.tearmsConditionsLabel = value.resourceValue;
            break;
          case "Admin.Header.Logout":
            LanguageStrings.logoutLabel = value.resourceValue;
            break;
          case "nop.MyAccountScreen.title.areYouSureWantToLogOut":
            LanguageStrings.logoutsubTitle = value.resourceValue;
            break;
          case "nop.MyAccountScreen.title.No":
            LanguageStrings.noLabelForMyAccount = value.resourceValue;
            break;
          case "nop.MyAccountScreen.title.Yes":
            LanguageStrings.yesLabelForMyAccount = value.resourceValue;
            break;
          case "Account.CustomerOrders":
            LanguageStrings.titleOrder = value.resourceValue;
            break;
          case "Account.CustomerOrders.NoOrders":
            LanguageStrings.noOrderLabel = value.resourceValue;
            break;
          case "Account.CustomerOrders.OrderNumber":
            LanguageStrings.orderNumberLabel = value.resourceValue;
            break;
          case "Account.CustomerOrders.OrderDetails":
            LanguageStrings.detailsLabel = value.resourceValue;
            break;
          case "Account.CustomerOrders.OrderStatus":
            LanguageStrings.orderStatusLabel = value.resourceValue;
            break;
          case "Admin.SalesReport.Incomplete.Total":
            LanguageStrings.orderTotalLabel = value.resourceValue;
            break;
          case "Order.OrderDate":
            LanguageStrings.orderDateLabel = value.resourceValue;
            break;
          case "Account.WishList.title":
            LanguageStrings.titleWish = value.resourceValue;
            break;
          case "Account.WishList.priceLabel":
            LanguageStrings.priceLabel = value.resourceValue;
            break;
          case "Account.WishList.totalLabel":
            LanguageStrings.totalLabelForWishList = value.resourceValue;
            break;
          case "Account.WishList.deleteLabel":
            LanguageStrings.deleteLabel = value.resourceValue;
            break;
          case "Account.WishList.emptyLabel":
            LanguageStrings.emptyLabel = value.resourceValue;
            break;
          case "Account.WishList.qtyLabel":
            LanguageStrings.qtyLabel = value.resourceValue;
            break;
          case "Account.WishList.dailogTitle":
            LanguageStrings.dailogTitle = value.resourceValue;
            break;
          case "Account.WishList.dailogLabel":
            LanguageStrings.dailogLabel = value.resourceValue;
            break;
          case "Account.WishList.yesLabelForWishList":
            LanguageStrings.yesLabelForWishList = value.resourceValue;
            break;
          case "Account.WishList.noLabelForWishList":
            LanguageStrings.noLabelForWishList = value.resourceValue;
            break;
          case "Account.WishList.shareLabel":
            LanguageStrings.shareLabel = value.resourceValue;
            break;
          case "Account.WishList.shareLabel1":
            LanguageStrings.shareLabel1 = value.resourceValue;
            break;
          case "Account.WishList.deleteLabel1":
            LanguageStrings.deleteLabel1 = value.resourceValue;
            break;
          case "Account.WishList.notDeleteLabel":
            LanguageStrings.notDeleteLabel = value.resourceValue;
            break;
          case "Admin.Customers.RewardPoints":
            LanguageStrings.titleRewardPoint = value.resourceValue;
            break;
          case "Account.RewardPointScreen.AppName":
            LanguageStrings.nopCommerceLabel = value.resourceValue;
            break;
          case "Admin.Customers.RewardPoints":
            LanguageStrings.rewardPointLabelForRewardScreen =
                value.resourceValue;
            break;
          case "Account.RewardPointScreen.ShortLable":
            LanguageStrings.shortLabel = value.resourceValue;
            break;
          case "Account.RewardPointScreen.currentPointLabel":
            LanguageStrings.currentPointLabel = value.resourceValue;
            break;
          case "RewardPoints.Fields.Points":
            LanguageStrings.pointLabel = value.resourceValue;
            break;
          case "Account.RewardPointScreen.PointShortLable":
            LanguageStrings.pointShortLabel = value.resourceValue;
            break;
          case "PageTitle.CustomerProductReviews":
            LanguageStrings.titleForReview = value.resourceValue;
            break;
          case "nop.MyAccountScreen.myProductReviewScreen.noReview":
            LanguageStrings.noReview = value.resourceValue;
            break;
          case "nop.MyAccountScreen.myAddress.title":
            LanguageStrings.titleForMyAddress = value.resourceValue;
            break;
          case "Account.CustomerAddresses.NoAddresses":
            LanguageStrings.addressFoundLabel = value.resourceValue;
            break;
          case "Admin.Customers.Customers.Addresses.AddButton":
            LanguageStrings.newAddressButtonLabel = value.resourceValue;
            break;
          case "Common.Edit":
            LanguageStrings.editLabel = value.resourceValue;
            break;
          case "Common.FileUploader.RemoveDownload":
            LanguageStrings.removeLabel = value.resourceValue;
            break;
          case "Common.Save":
            LanguageStrings.saveLabel = value.resourceValue;
            break;
          case "Address.Fields.Email":
            LanguageStrings.emailLabel = value.resourceValue;
            break;
          case "Address.Fields.PhoneNumber":
            LanguageStrings.phoneLabel = value.resourceValue;
            break;
          case "Admin.Address.Fields.FaxNumber":
            LanguageStrings.faxLabel = value.resourceValue;
            break;
          case "nop.MyAccountScreen.myAddress.removeSubTitleForAddress":
            LanguageStrings.removeSubTitleForAddress = value.resourceValue;
            break;
          case "Common.Yes":
            LanguageStrings.yesLabelForAddress = value.resourceValue;
            break;
          case "Common.No":
            LanguageStrings.noLabelForAddress = value.resourceValue;
            break;
          case "nop.MyAccountScreen.myAddress.addressRemovedToast":
            LanguageStrings.addressRemovedToast = value.resourceValue;
            break;
          case "nop.MyAccountScreen.myAddress.addressNotRemovedToast":
            LanguageStrings.addressNotRemovedToast = value.resourceValue;
            break;
          case "Account.DownloadableProducts":
            LanguageStrings.titleForDownloadable = value.resourceValue;
            break;
          case "Admin.Affiliates.Orders.CustomOrderNumber":
            LanguageStrings.orderHashTag = value.resourceValue;
            break;
          case "Admin.DownloadableProducts.Downloaded":
            LanguageStrings.downloaded = value.resourceValue;
            break;
          case "DownloadableProducts.NoItems":
            LanguageStrings.noProdutcts = value.resourceValue;
            break;
          case "PageTitle.ContactUs":
            LanguageStrings.titleContactUs = value.resourceValue;
            break;
          case "PageTitle.ContactUs.subTitle":
            LanguageStrings.subTitle = value.resourceValue;
            break;
          case "String PageTitle.ContactUs.description":
            LanguageStrings.description = value.resourceValue;
            break;
          case "ContactUs.FullName":
            LanguageStrings.strYourName = value.resourceValue;
            break;
          case "ContactUs.FullName.Hint":
            LanguageStrings.strEmptyName = value.resourceValue;
            break;
          case "ContactUs.Email":
            LanguageStrings.strYourEmail = value.resourceValue;
            break;
          case "ContactUs.Email.Hint":
            LanguageStrings.strErrorEmptyEmailOrPhoneContactUs =
                value.resourceValue;
            break;
          case "ContactUs.Enquiry":
            LanguageStrings.strEnquiry = value.resourceValue;
            break;
          case "ContactUs.Enquiry.Hint":
            LanguageStrings.strErrorEmptyEnquiry = value.resourceValue;
            break;
          case "ContactUs.Button":
            LanguageStrings.btnSubmitContactUs = value.resourceValue;
            break;
          case "PageTitle.ContactUs.ReviewNotSubmitted":
            LanguageStrings.reviewNotSubmitedToast = value.resourceValue;
            break;
          case "ContactUs.YourEnquiryHasBeenSent":
            LanguageStrings.EnquiryToast = value.resourceValue;
            break;
          case "Admin.Common.Ok":
            LanguageStrings.strOK = value.resourceValue;
            break;
          case "Admin.Orders.Fields.ShippingMethod":
            LanguageStrings.titleForShippingMethod = value.resourceValue;
            break;
          case "Order.SubTotal":
            LanguageStrings.strSubTotal = value.resourceValue;
            break;
          case "Admin.Orders.Fields.Edit.OrderSubTotalDiscount":
            LanguageStrings.strSubTotalDiscount = value.resourceValue;
            break;
          case "Admin.Orders.Fields.OrderShipping":
            LanguageStrings.strShipping = value.resourceValue;
            break;
          case "Admin.Orders.Fields.Tax":
            LanguageStrings.strTax = value.resourceValue;
            break;
          case "Admin.Orders.Fields.ShippingMethod.strOrderTotalDiscount":
            LanguageStrings.strOrderTotalDiscount = value.resourceValue;
            break;
          case "Admin.Orders.Fields.ShippingMethod.strEarn":
            LanguageStrings.strEarn = value.resourceValue;
            break;
          case "Admin.Customers.Customers.RewardPoints":
            LanguageStrings.strPoints = value.resourceValue;
            break;
          case "Admin.Orders.Fields.Edit.OrderTotal":
            LanguageStrings.strTotal = value.resourceValue;
            break;
          case "Checkout.ThankYou.Continue":
            LanguageStrings.btnContinue = value.resourceValue;
            break;
          case "PDFInvoice.ProductQuantity":
            LanguageStrings.strQty = value.resourceValue;
            break;
          case "Admin.Orders.Fields.InternetToast":
            LanguageStrings.InternetToast = value.resourceValue;
            break;
          case "Admin.ContentManagement.Topics.Fields.Password":
            LanguageStrings.strPasswordScreenTitle = value.resourceValue;
            break;
          case "Admin.ContentManagement.Topics.Fields.Password":
            LanguageStrings.passwordWithSpace = value.resourceValue;
            break;
          case "PageTitle.ContactUs.ReviewNotSubmitted":
            LanguageStrings.strCreate = value.resourceValue;
            break;
          case "Admin.Orders.Products.Download.ResetDownloadCount":
            LanguageStrings.strReset = value.resourceValue;
            break;
          case "Admin.Common.Change":
            LanguageStrings.strChangePassword = value.resourceValue;
            break;
          case "Nop.Password.DontShare":
            LanguageStrings.strDoNotSharePassword = value.resourceValue;
            break;
          case "Account.ChangePassword.Fields.OldPassword":
            LanguageStrings.strHintOldPassword = value.resourceValue;
            break;
          case "Account.ChangePassword.Fields.OldPassword":
            LanguageStrings.strErrorEmptyOldPassword = value.resourceValue;
            break;
          case "Account.PasswordRecovery.NewPassword":
            LanguageStrings.strHintNewPassword = value.resourceValue;
            break;
          case "Account.PasswordRecovery.NewPassword.NewPasswordIsRequired":
            LanguageStrings.strErrorEmptyNewPassword = value.resourceValue;
            break;
          case "Account.ChangePassword.Fields.ConfirmNewPassword":
            LanguageStrings.strHintConfirmPassword = value.resourceValue;
            break;
          case "Account.Fields.ConfirmPassword.Required":
            LanguageStrings.strErrorEmptyConfirmPassword = value.resourceValue;
            break;
          case "Forum.Submit":
            LanguageStrings.btnSubmitInPassword = value.resourceValue;
            break;
          case "Nop.Account.Password.SuccessToast":
            LanguageStrings.msgSuccess = value.resourceValue;
            break;
          case "Nop.Account.Password.fail":
            LanguageStrings.failToResetPassword = value.resourceValue;
            break;
          case "Nop.Error.SomethingWentWrong":
            LanguageStrings.somethingWentsWrong = value.resourceValue;
            break;
          case "Nop.Account.Password.Reason":
            LanguageStrings.strReson = value.resourceValue;
            break;
          case "Common.OK":
            LanguageStrings.okInPassword = value.resourceValue;
            break;
          case "Account.ChangePassword.Fields.NewPassword.EnteredPasswordsDoNotMatch":
            LanguageStrings.confirmPasswordDoesntMatch = value.resourceValue;
            break;
          case "Admin.System.QueuedEmails.Fields.From":
            LanguageStrings.strFrom = value.resourceValue;
            break;
          case "Checkout.ConfirmOrder":
            LanguageStrings.titleForConfirmOrder = value.resourceValue;
            break;
          case "Order.BillingAddress":
            LanguageStrings.strBillingAddress = value.resourceValue;
            break;
          case "Order.Shipments.ShippingAddress":
            LanguageStrings.strShippingAddress = value.resourceValue;
            break;
          case "Vendors.ApplyAccount.Email":
            LanguageStrings.strEmail = value.resourceValue;
            break;
          case "Account.Fields.Phone":
            LanguageStrings.strPhone = value.resourceValue;
            break;
          case "Address.Fields.FaxNumber":
            LanguageStrings.strFax = value.resourceValue;
            break;
          case "Admin.Configuration.Settings.Tax.BlockTitle.Payment":
            LanguageStrings.strPayment = value.resourceValue;
            break;
          case "Admin.Orders.Fields.PaymentMethod":
            LanguageStrings.strPaymentMethod = value.resourceValue;
            break;
          case "Admin.Orders.Report.Shipping":
            LanguageStrings.strShippingForConfirmOrder = value.resourceValue;
            break;
          case "Order.Shipments.ShippingMethod":
            LanguageStrings.strShippingMethod = value.resourceValue;
            break;
          case "PDFInvoice.ProductQuantity":
            LanguageStrings.strQtyForConfirmOrder = value.resourceValue;
            break;
          case "ShoppingCart.Totals.SubTotal":
            LanguageStrings.strSubTotalForConfirmOrder = value.resourceValue;
            break;
          case "ShoppingCart.Totals.Tax":
            LanguageStrings.strTaxForConfirmOrder = value.resourceValue;
            break;
          case "Nop.cart.checkout.strOrderTotalDiscount":
            LanguageStrings.strOrderTotalDiscountForConfirmOrder =
                value.resourceValue;
            break;
          case "Nop.cart.checkout.strEarn":
            LanguageStrings.strEarnForConfirmOrder = value.resourceValue;
            break;
          case "Admin.Customers.Customers.RewardPoints.Fields.Points":
            LanguageStrings.strPointsForConfirmOrder = value.resourceValue;
            break;
          case "Admin.Orders.Products.Total":
            LanguageStrings.strTotalForConfirmOrder = value.resourceValue;
            break;
          case "Checkout.ConfirmButton":
            LanguageStrings.btnConfirmLabel = value.resourceValue;
            break;
          case "Nop.cart.checkout.InternetToast":
            LanguageStrings.InternetToastForConfirmOrder = value.resourceValue;
            break;
          case "Nop.Checkout.Title":
            LanguageStrings.titleForCheckout = value.resourceValue;
            break;
          case "Checkout.ThankYou.Continue":
            LanguageStrings.btnContinueLabel = value.resourceValue;
            break;
          case "Account.CustomerAddresses.AddNew":
            LanguageStrings.btnNewAddresslabel = value.resourceValue;
            break;
          case "Account.CustomerAddresses.Edit":
            LanguageStrings.strEditAddress = value.resourceValue;
            break;
          case "Account.CustomerAddresses.Change":
            LanguageStrings.strChangeAddress = value.resourceValue;
            break;
          case "Nop.Checkout.EmailWithComa":
            LanguageStrings.strEmailWithComa = value.resourceValue;
            break;
          case "Nop.Checkout.PhoneWithComa":
            LanguageStrings.strPhoneWithComa = value.resourceValue;
            break;
          case "Nop.Checkout.FaxNumberWithComa":
            LanguageStrings.strFaxWithComa = value.resourceValue;
            break;
          case "Nop.Checkout.strQtyWithComa":
            LanguageStrings.strQtyWithComa = value.resourceValue;
            break;
          case "Checkout.EnterShippingAddress":
            LanguageStrings.shippingAddressToast = value.resourceValue;
            break;
          case "Checkout.EnterBillingAddress":
            LanguageStrings.billingAddressToast = value.resourceValue;
            break;
          case "Nop.Checkout.Success.subTitle":
            LanguageStrings.subTitleForOrderPlaceSuccess = value.resourceValue;
            break;
          case "Admin.Configuration.Settings.Order.OrderIdent":
            LanguageStrings.strOrderId = value.resourceValue;
            break;
          case "Nop.Checkout.Success.strDescription":
            LanguageStrings.strDescription = value.resourceValue;
            break;
          case "PageTitle.OrderDetails":
            LanguageStrings.strOrderDetails = value.resourceValue;
            break;
          case "Nop.Checkout.Success.strDone":
            LanguageStrings.strDone = value.resourceValue;
            break;
          case "Account.Register.Result.EmailValidation":
            LanguageStrings.subtitle = value.resourceValue;
            break;
          case "Account.Register.Result.Continue":
            LanguageStrings.btnContinueLabelEmailInstructionScreen =
                value.resourceValue;
            break;
          case "nop.noInternetScreen.strOops":
            LanguageStrings.strOops = value.resourceValue;
            break;
          case "nop.noInternetScreen.strSomethingWentWrong":
            LanguageStrings.strSomethingWentWrong = value.resourceValue;
            break;
          case "Admin.Customers.Customers.Addresses.AddButton":
            LanguageStrings.strNewAddressScreen = value.resourceValue;
            break;
          case "Admin.Customers.Customers.Fields.FirstName":
            LanguageStrings.strHintFirstName = value.resourceValue;
            break;
          case "Admin.Customers.Customers.Fields.LastName":
            LanguageStrings.strHintLastName = value.resourceValue;
            break;
          case "Admin.Customers.Customers.List.SearchEmail":
            LanguageStrings.strHintEmail = value.resourceValue;
            break;
          case "Admin.Address.Fields.Company":
            LanguageStrings.strCompany = value.resourceValue;
            break;
          case "Admin.Address.Fields.Country":
            LanguageStrings.strCountry = value.resourceValue;
            break;
          case "Admin.Address.Fields.StateProvince":
            LanguageStrings.strState = value.resourceValue;
            break;
          case "Admin.Address.Fields.City":
            LanguageStrings.strCity = value.resourceValue;
            break;
          case "Admin.Orders.Address.Address1":
            LanguageStrings.strAddress1 = value.resourceValue;
            break;
          case "Admin.Orders.Address.Address2":
            LanguageStrings.strAddress2 = value.resourceValue;
            break;
          case "Admin.Orders.Address.ZipPostalCode":
            LanguageStrings.strPinCode = value.resourceValue;
            break;
          case "Admin.Address.Fields.PhoneNumber":
            LanguageStrings.strPhone = value.resourceValue;
            break;
          case "Admin.Address.Fields.FaxNumber":
            LanguageStrings.strFax = value.resourceValue;
            break;
          case "Common.Save":
            LanguageStrings.btnSaveLabel = value.resourceValue;
            break;
          case "Account.Fields.FirstName.Required":
            LanguageStrings.strFirstNameRequired = value.resourceValue;
            break;
          case "Account.Fields.LastName.Required":
            LanguageStrings.strLastNameRequired = value.resourceValue;
            break;
          case "Account.Register.Errors.EmailIsNotProvided":
            LanguageStrings.strEmailRequired = value.resourceValue;
            break;
          case "Admin.Customers.Customers.Fields.Company.Required":
            LanguageStrings.strCompanyRequired = value.resourceValue;
            break;
          case "Address.Fields.Country.Required":
            LanguageStrings.strCountryRequired = value.resourceValue;
            break;
          case "Address.Fields.StateProvince.Required":
            LanguageStrings.strStateRequired = value.resourceValue;
            break;
          case "Address.Fields.City.Required":
            LanguageStrings.strCityRequired = value.resourceValue;
            break;
          case "Admin.Customers.Customers.Fields.StreetAddress.Required":
            LanguageStrings.strAddress1Required = value.resourceValue;
            break;
          case "Admin.Customers.Customers.Fields.StreetAddress2.Required":
            LanguageStrings.strAddress2Required = value.resourceValue;
            break;
          case "Admin.Customers.Customers.Fields.ZipPostalCode.Required":
            LanguageStrings.strPinCodeRequired = value.resourceValue;
            break;
          case "Admin.Customers.Customers.Fields.Phone.Required":
            LanguageStrings.strPhoneRequired = value.resourceValue;
            break;
          case "Admin.Customers.Customers.Fields.Fax.Required":
            LanguageStrings.strFaxRequired = value.resourceValue;
            break;
          case "Address.SelectCountry":
            LanguageStrings.strSelectCountry = value.resourceValue;
            break;
          case "Address.SelectState":
            LanguageStrings.strSelectState = value.resourceValue;
            break;
          case "Admin.Customers.Customers.Addresses.EditAddress":
            LanguageStrings.strEditAddressNewAddressScreen =
                value.resourceValue;
            break;
          case "Admin.Customers.Customers.Addresses.Updated":
            LanguageStrings.updateAddressToast = value.resourceValue;
            break;
          case "Admin.Customers.Customers.Addresses.Added":
            LanguageStrings.addAddressToast = value.resourceValue;
            break;
        }
      }
    }
    return null;
  }

  bool checkForNull(Map map, String key) {
    return map != null &&
        map.containsKey(key) &&
        map[key] != null &&
        map[key].toString().isNotEmpty;
  }
}
