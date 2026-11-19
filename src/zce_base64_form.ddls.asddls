@EndUserText.label: 'Adobe Form Base64 Converter'
@ObjectModel.query.implementedBy: 'ABAP:ZCL_XDP_BASE64_CONV'
define custom entity ZCE_BASE64_FORM
{
  key FormTemplate : abap.char(100);
      Base64Xdp    : abap.string(0);
};
