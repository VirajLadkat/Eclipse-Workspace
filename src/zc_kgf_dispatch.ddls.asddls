@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'KGFlexx Dispatch Report - Consumption View'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType: {
  serviceQuality: #C,
  sizeCategory:   #XXL,
  dataClass:      #MIXED
}
@Metadata.allowExtensions: true

define root view entity ZC_KGF_DISPATCH
  as projection on ZI_KGF_DISPATCH
  //provider contract transactional_query

{
  key DeliveryDocument,
  key DeliveryDocumentItem,

      SalesOrder,
      SalesOrderItem,
      MaterialCode,
      RollNumber,
      MaterialGroup,
      MaterialType,

      _BatchCharc.Length,
      _BatchCharc.Width,
      _BatchCharc.OD,
      _BatchCharc.CoreID,
      _BatchCharc.Treatment,
      _BatchCharc.GrossWeight,
      _BatchCharc.NetWeight,
      _BatchCharc.Remark,
      _BatchCharc.Grade,

      PackingMode,
      StorageLocation,
      DeliveryDate,
      BillingNumber,
      BillingDate,
      DateOfManufacture,
      SoldToParty,
      ShipToParty,
      Destination,
      VehicleNumber,
      ContainerNumber,
      Plant,
      DistributionChannel,
      DistributionChannelName,
      SalesEmployee,
      BatchClassification,
      ClfnObjectInternalID,

      _BatchCharc,
      _DelHeader,
      _Billing,
      _Batch,
      _SalesOrderItem,
      _SalesEmp,
      _DistChTxt
}
