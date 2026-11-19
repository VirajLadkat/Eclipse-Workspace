@Metadata.allowExtensions: true
//@Metadata.ignorePropagatedAnnotations: true
@EndUserText: {
  label: 'Adobe Form Template Store'
}
@ObjectModel: {
  sapObjectNodeType.name: 'ZADOBE_STORE000'
}
@AccessControl.authorizationCheck: #MANDATORY
define root view entity ZC_ADOBE_STORE
  provider contract transactional_query
  as projection on ZR_ADOBE_STORE
  association [1..1] to ZR_ADOBE_STORE as _BaseEntity on $projection.Formtemplate = _BaseEntity.Formtemplate
{

  @EndUserText.label: 'Form Template'
  key Formtemplate,
  
 @EndUserText.label: 'Upload Adobe Form(XDP)'
  Attachment,

  Mimetypexsd,
  Mimetypexdp,
 @EndUserText.label: 'XSD File name'  
  Filenamexsd,
  
 @EndUserText.label: 'XDP File name'
  Filenamexdp,
        
 @EndUserText.label: 'Upload Schema(XSD)' 
  Zschema,
  @Semantics: {
    user.createdBy: true
  }
  Createdby,
  @Semantics: {
    systemDateTime.createdAt: true
  }
  Createdat,
  @Semantics: {
    user.localInstanceLastChangedBy: true
  }
  Lastchangedby,
  @Semantics: {
    systemDateTime.localInstanceLastChangedAt: true
  }
  Lastchangedat,
  @Semantics: {
    systemDateTime.lastChangedAt: true
  }
  Locallastchangedat,
  _BaseEntity
}
