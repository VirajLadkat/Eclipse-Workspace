@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'KGFlexx Batch Classification Helper'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType: {
  serviceQuality: #X,
  sizeCategory:   #XL,
  dataClass:      #MIXED
}

define view entity ZI_KGF_BATCHCHARC
  as select from I_ClfnObjectCharcValue as Charc
    inner join I_ClfnCharacteristic as CharcDef
      on CharcDef.CharcInternalID = Charc.CharcInternalID

{
  key Charc.ClfnObjectID,

  max( case CharcDef.Characteristic
         when 'KGF_LENGTH'         then Charc.CharcFromNumericValue
         else cast( 0 as abap.dec(31,14) )
       end ) as Length,
  max( case CharcDef.Characteristic
         when 'KGF_WIDTH'          then Charc.CharcFromNumericValue
         else cast( 0 as abap.dec(31,14) )
       end ) as Width,
  max( case CharcDef.Characteristic
         when 'KGF_OUTER DIAMETER' then Charc.CharcFromNumericValue
         else cast( 0 as abap.dec(31,14) )
       end ) as OD,
  max( case CharcDef.Characteristic
         when 'KGF_INNER_DIAMETER' then Charc.CharcFromNumericValue
         else cast( 0 as abap.dec(31,14) )
       end ) as CoreID,
  max( case CharcDef.Characteristic
         when 'KGF_TREATSIDE'      then Charc.CharcFromNumericValue
         else cast( 0 as abap.dec(31,14) )
       end ) as Treatment,
  max( case CharcDef.Characteristic
         when 'KGF_GROSSWT2'       then Charc.CharcFromNumericValue
         else cast( 0 as abap.dec(31,14) )
       end ) as GrossWeight,
  max( case CharcDef.Characteristic
         when 'KGF_NETWT2'         then Charc.CharcFromNumericValue
         else cast( 0 as abap.dec(31,14) )
       end ) as NetWeight,
  max( case CharcDef.Characteristic
         when 'KGF_REMARKS'        then Charc.CharcValue
         else cast( ' ' as abap.char(70) )
       end ) as Remark,
  max( case CharcDef.Characteristic
         when 'KGF_NEW_GRADE'      then Charc.CharcValue
         else cast( ' ' as abap.char(70) )
       end ) as Grade
}
group by Charc.ClfnObjectID
