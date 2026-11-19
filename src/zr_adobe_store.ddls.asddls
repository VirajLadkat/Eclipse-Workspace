@AccessControl.authorizationCheck: #MANDATORY
@Metadata.allowExtensions: true
@ObjectModel.sapObjectNodeType.name: 'ZADOBE_STORE000'
@EndUserText.label: '###GENERATED Core Data Service Entity'
define root view entity ZR_ADOBE_STORE
  as select from zdt_adobe_store
{

      @EndUserText.label: 'Form Template'
  key formtemplate       as Formtemplate,

      @Semantics.largeObject:{
           mimeType: 'mimetypexdp',
           fileName: 'filenamexdp',
           contentDispositionPreference: #ATTACHMENT
         }
      @EndUserText.label: 'Upload XDP'
      attachment         as Attachment,
      mimetypexsd        as Mimetypexsd,
      mimetypexdp        as Mimetypexdp,

      @EndUserText.label: 'XSD File name'
      filenamexsd        as Filenamexsd,

      @EndUserText.label: 'XDP File name'
      filenamexdp        as Filenamexdp,


      @Semantics.largeObject:{
           mimeType: 'mimetypexsd',
           fileName: 'filenamexsd',
           contentDispositionPreference: #ATTACHMENT
         }

      @EndUserText.label: 'Upload XSD'
      zschema            as Zschema,
      @Semantics.user.createdBy: true
      createdby          as Createdby,
      @Semantics.systemDateTime.createdAt: true
      createdat          as Createdat,
      @Semantics.user.localInstanceLastChangedBy: true
      lastchangedby      as Lastchangedby,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      lastchangedat      as Lastchangedat,
      @Semantics.systemDateTime.lastChangedAt: true
      locallastchangedat as Locallastchangedat
}
