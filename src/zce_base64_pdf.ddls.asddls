@EndUserText.label: 'Generate Pdf Through API'
@ObjectModel.query.implementedBy: 'ABAP:ZCL_XDP_BASE64_CONV'
define custom entity ZCE_BASE64_PDF
{
      @Consumption.filter.mandatory: true
  key FormTemplate : abap.char(100);
      @Consumption.filter.mandatory: true
  key XMLData      : abap.string(0);
      Base64PDF    : abap.string(0);
};
