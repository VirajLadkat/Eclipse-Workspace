@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'KGFlexx Dispatch Report - Interface View'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType: {
  serviceQuality: #X,
  sizeCategory:   #XXL,
  dataClass:      #MIXED
}

define root view entity ZI_KGF_DISPATCH
  as select from I_DeliveryDocumentItem as DelItem

  left outer join I_Batch as Batch
    on  Batch.Material = DelItem.Product
    and Batch.Batch    = DelItem.Batch
    and Batch.Plant    = DelItem.Plant

  association [0..1] to I_SalesOrderItem         as _SalesOrderItem
    on  _SalesOrderItem.SalesOrder     = DelItem.ReferenceSDDocument
    and _SalesOrderItem.SalesOrderItem = DelItem.ReferenceSDDocumentItem

  association [0..1] to I_DeliveryDocument        as _DelHeader
    on  _DelHeader.DeliveryDocument = DelItem.DeliveryDocument

  association [0..1] to I_BillingDocumentItem     as _Billing
    on  _Billing.ReferenceSDDocument     = DelItem.DeliveryDocument
    and _Billing.ReferenceSDDocumentItem = DelItem.DeliveryDocumentItem

  association [0..1] to I_Batch                   as _Batch
    on  _Batch.Material = DelItem.Product
    and _Batch.Batch    = DelItem.Batch
    and _Batch.Plant    = DelItem.Plant

  association [0..1] to I_SalesDocumentPartner    as _SalesEmp
    on  _SalesEmp.SalesDocument   = DelItem.ReferenceSDDocument
    and _SalesEmp.PartnerFunction = 'VE'

  association [0..1] to I_DistributionChannelText as _DistChTxt
    on  _DistChTxt.DistributionChannel = DelItem.DistributionChannel
    and _DistChTxt.Language            = $session.system_language

  association [0..1] to I_Product                 as _Product
    on  _Product.Product = DelItem.Product

  // Join BatchCharc using I_Batch._ClfnObjectCharcValForKeyDate path
  // ClfnObjectID on I_ClfnObjectCharcValue = objekp
  // which matches Batch internal classification object
  association [0..1] to ZI_KGF_BATCHCHARC         as _BatchCharc
    on  _BatchCharc.ClfnObjectID = Batch.ClfnObjectInternalID

{
  key DelItem.DeliveryDocument,
  key DelItem.DeliveryDocumentItem,

      DelItem.ReferenceSDDocument           as SalesOrder,
      DelItem.ReferenceSDDocumentItem       as SalesOrderItem,
      DelItem.Product                       as MaterialCode,
      DelItem.Batch                         as RollNumber,
      DelItem.MaterialGroup,
      DelItem.StorageLocation,
      DelItem.Plant,
      DelItem.DistributionChannel,
      DelItem.BatchClassification,

      // Bridge field — must be in select for association to resolve
      Batch.ClfnObjectInternalID            as ClfnObjectInternalID,

      _Product.ProductType                  as MaterialType,
      DelItem.YY1_PACKINGMODE_DLI           as PackingMode,

      _DelHeader.DeliveryDate,
      _DelHeader.SoldToParty,
      _DelHeader.ShipToParty,
      _DelHeader.YY1_CountryofFinalDes_DLH  as Destination,
      _DelHeader.YY1_VehicleNumber_DL_DLH   as VehicleNumber,
      _DelHeader.YY1_ContainerNumber_DLH    as ContainerNumber,

      _Billing.BillingDocument              as BillingNumber,
      _Billing.BillingDocumentDate          as BillingDate,
      _Billing.SoldToParty                  as BillingSoldToParty,
      _Billing.ShipToParty                  as BillingShipToParty,
      _Billing.DistributionChannel          as BillingDistributionChannel,

      _DistChTxt.DistributionChannelName,
      _Batch.ManufactureDate                as DateOfManufacture,
      _SalesEmp.FullName                    as SalesEmployee,

      _SalesOrderItem,
      _DelHeader,
      _Billing,
      _Batch,
      _SalesEmp,
      _DistChTxt,
      _BatchCharc
}
