CLASS zcl_adobe_generate DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    TYPES :
      BEGIN OF struct,
        xdp_template TYPE string,
        xml_data     TYPE string,
        form_type    TYPE string,
        form_locale  TYPE string,
        tagged_pdf   TYPE string,
        embed_font   TYPE string,
      END OF struct.

    TYPES: BEGIN OF ty_base64xdp,
             FormTemplate TYPE string,
             Base64Xdp    TYPE string,
           END OF ty_base64xdp.

    TYPES: tt_base64xdp TYPE TABLE OF ty_base64xdp WITH EMPTY KEY.

    CLASS-METHODS: base64_converter
      IMPORTING VALUE(iv_template)   TYPE string
      RETURNING VALUE(et_base64_xdp) TYPE tt_base64xdp.
    CLASS-METHODS :
      generate_pdf
        IMPORTING
                  iv_form_name     TYPE string
                  iv_xml           TYPE string
        EXPORTING VALUE(ev_status) TYPE c
        RETURNING VALUE(rv_result) TYPE string
        RAISING   cx_static_check .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_ADOBE_GENERATE IMPLEMENTATION.


  METHOD base64_converter.

    DATA lt_adobe_store TYPE TABLE OF zdt_adobe_store WITH EMPTY KEY.

    SELECT *
        FROM zdt_adobe_store
        WHERE upper( formtemplate ) = @( to_upper( iv_template ) )
    INTO TABLE @lt_adobe_store.

    IF lt_adobe_store IS INITIAL.
      RETURN.
    ENDIF.

    LOOP AT lt_adobe_store INTO DATA(ls_adobe_store).
      DATA(lv_base64_xdp) = cl_web_http_utility=>encode_x_base64( ls_adobe_store-attachment ).

      APPEND VALUE ty_base64xdp(
        formtemplate = ls_adobe_store-formtemplate
        base64xdp    = lv_base64_xdp
      ) TO et_base64_xdp.
    ENDLOOP.

  ENDMETHOD.


  METHOD generate_pdf .
    DATA ev_pdf          TYPE xstring.
    DATA ev_pages        TYPE int4.
    DATA ev_trace_string TYPE string.
    DATA iv_xml_data     TYPE xstring.
    DATA ls_data_xml     TYPE xstring.
    DATA iv_xdp_layout   TYPE xstring.
    DATA iv_locale       TYPE string.
    DATA(lv_xmldata) =  iv_xml.
*    REPLACE ALL OCCURRENCES OF '\t' IN lv_xmldata WITH '&#9;'.
*    REPLACE ALL OCCURRENCES OF '\n' IN lv_xmldata WITH '&#10;'.
*    REPLACE ALL OCCURRENCES OF '\r' IN lv_xmldata WITH '&#13;'.
*    REPLACE ALL OCCURRENCES OF '!' IN lv_xmldata WITH '&#33;'.
**   REPLACE ALL OCCURRENCES OF '"' IN lv_xmldata WITH '&#34;'.
**   REPLACE ALL OCCURRENCES OF '#' IN lv_xmldata WITH '&#35;'.
*    REPLACE ALL OCCURRENCES OF '$' IN lv_xmldata WITH '&#36;'.
**   REPLACE ALL OCCURRENCES OF '%' IN lv_xmldata WITH '&#37;'.
*    REPLACE ALL OCCURRENCES OF '&' IN lv_xmldata WITH '&#38;'.
**   REPLACE ALL OCCURRENCES OF |'| IN lv_xmldata WITH '&#39;'.
*    REPLACE ALL OCCURRENCES OF '(' IN lv_xmldata WITH '&#40;'.
*    REPLACE ALL OCCURRENCES OF ')' IN lv_xmldata WITH '&#41;'.
*    REPLACE ALL OCCURRENCES OF '*' IN lv_xmldata WITH '&#42;'.
*    REPLACE ALL OCCURRENCES OF '+' IN lv_xmldata WITH '&#43;'.
**   REPLACE ALL OCCURRENCES OF ',' IN lv_xmldata WITH '&#44;'.
**   REPLACE ALL OCCURRENCES OF '-' IN lv_xmldata WITH '&#45;'.
**   REPLACE ALL OCCURRENCES OF '.' IN lv_xmldata WITH '&#46;'.
**   REPLACE ALL OCCURRENCES OF '/' IN lv_xmldata WITH '&#47;'.
*    REPLACE ALL OCCURRENCES OF ':' IN lv_xmldata WITH '&#58;'.
**   REPLACE ALL OCCURRENCES OF ';' IN lv_xmldata WITH '&#59;'.
**   REPLACE ALL OCCURRENCES OF '<' IN lv_xmldata WITH '&#60;'.
*    REPLACE ALL OCCURRENCES OF '=' IN lv_xmldata WITH '&#61;'.
**   REPLACE ALL OCCURRENCES OF '>' IN lv_xmldata WITH '&#62;'.
*    REPLACE ALL OCCURRENCES OF '?' IN lv_xmldata WITH '&#63;'.
*    REPLACE ALL OCCURRENCES OF '@' IN lv_xmldata WITH '&#64;'.
*    REPLACE ALL OCCURRENCES OF '[' IN lv_xmldata WITH '&#91;'.
**   REPLACE ALL OCCURRENCES OF '\' IN lv_xmldata WITH '&#92;'.
*    REPLACE ALL OCCURRENCES OF ']' IN lv_xmldata WITH '&#93;'.
*    REPLACE ALL OCCURRENCES OF '^' IN lv_xmldata WITH '&#94;'.
**   REPLACE ALL OCCURRENCES OF '_' IN lv_xmldata WITH '&#95;'.
*    REPLACE ALL OCCURRENCES OF '`' IN lv_xmldata WITH '&#96;'.
*    REPLACE ALL OCCURRENCES OF '{' IN lv_xmldata WITH '&#123;'.
*    REPLACE ALL OCCURRENCES OF '|' IN lv_xmldata WITH '&#124;'.
*    REPLACE ALL OCCURRENCES OF '}' IN lv_xmldata WITH '&#125;'.
*    REPLACE ALL OCCURRENCES OF '~' IN lv_xmldata WITH '&#126;'.
*    REPLACE ALL OCCURRENCES OF '€' IN lv_xmldata WITH '&#128;'.
*    REPLACE ALL OCCURRENCES OF '‚' IN lv_xmldata WITH '&#130;'.
*    REPLACE ALL OCCURRENCES OF 'ƒ' IN lv_xmldata WITH '&#131;'.
*    REPLACE ALL OCCURRENCES OF '„' IN lv_xmldata WITH '&#132;'.
*    REPLACE ALL OCCURRENCES OF '…' IN lv_xmldata WITH '&#133;'.
*    REPLACE ALL OCCURRENCES OF '†' IN lv_xmldata WITH '&#134;'.
*    REPLACE ALL OCCURRENCES OF '‡' IN lv_xmldata WITH '&#135;'.
*    REPLACE ALL OCCURRENCES OF 'ˆ' IN lv_xmldata WITH '&#136;'.
*    REPLACE ALL OCCURRENCES OF '‰' IN lv_xmldata WITH '&#137;'.
*    REPLACE ALL OCCURRENCES OF 'Š' IN lv_xmldata WITH '&#138;'.
*    REPLACE ALL OCCURRENCES OF '‹' IN lv_xmldata WITH '&#139;'.
*    REPLACE ALL OCCURRENCES OF 'Œ' IN lv_xmldata WITH '&#140;'.
*    REPLACE ALL OCCURRENCES OF 'Ž' IN lv_xmldata WITH '&#142;'.
*    REPLACE ALL OCCURRENCES OF '‘' IN lv_xmldata WITH '&#145;'.
*    REPLACE ALL OCCURRENCES OF '’' IN lv_xmldata WITH '&#146;'.
*    REPLACE ALL OCCURRENCES OF '“' IN lv_xmldata WITH '&#147;'.
*    REPLACE ALL OCCURRENCES OF '”' IN lv_xmldata WITH '&#148;'.
*    REPLACE ALL OCCURRENCES OF '•' IN lv_xmldata WITH '&#149;'.
*    REPLACE ALL OCCURRENCES OF '–' IN lv_xmldata WITH '&#150;'.
*    REPLACE ALL OCCURRENCES OF '—' IN lv_xmldata WITH '&#151;'.
*    REPLACE ALL OCCURRENCES OF '˜' IN lv_xmldata WITH '&#152;'.
*    REPLACE ALL OCCURRENCES OF '™' IN lv_xmldata WITH '&#153;'.
*    REPLACE ALL OCCURRENCES OF 'š' IN lv_xmldata WITH '&#154;'.
*    REPLACE ALL OCCURRENCES OF '›' IN lv_xmldata WITH '&#155;'.
*    REPLACE ALL OCCURRENCES OF 'œ' IN lv_xmldata WITH '&#156;'.
*    REPLACE ALL OCCURRENCES OF 'ž' IN lv_xmldata WITH '&#158;'.
*    REPLACE ALL OCCURRENCES OF 'Ÿ' IN lv_xmldata WITH '&#159;'.
*    REPLACE ALL OCCURRENCES OF '¡' IN lv_xmldata WITH '&#161;'.
*    REPLACE ALL OCCURRENCES OF '¢' IN lv_xmldata WITH '&#162;'.
*    REPLACE ALL OCCURRENCES OF '£' IN lv_xmldata WITH '&#163;'.
*    REPLACE ALL OCCURRENCES OF '¤' IN lv_xmldata WITH '&#164;'.
*    REPLACE ALL OCCURRENCES OF '¥' IN lv_xmldata WITH '&#165;'.
*    REPLACE ALL OCCURRENCES OF '¦' IN lv_xmldata WITH '&#166;'.
*    REPLACE ALL OCCURRENCES OF '§' IN lv_xmldata WITH '&#167;'.
*    REPLACE ALL OCCURRENCES OF '¨' IN lv_xmldata WITH '&#168;'.
*    REPLACE ALL OCCURRENCES OF '©' IN lv_xmldata WITH '&#169;'.
*    REPLACE ALL OCCURRENCES OF 'ª' IN lv_xmldata WITH '&#170;'.
*    REPLACE ALL OCCURRENCES OF '«' IN lv_xmldata WITH '&#171;'.
*    REPLACE ALL OCCURRENCES OF '¬' IN lv_xmldata WITH '&#172;'.
*    REPLACE ALL OCCURRENCES OF '®' IN lv_xmldata WITH '&#174;'.
*    REPLACE ALL OCCURRENCES OF '¯' IN lv_xmldata WITH '&#175;'.
*    REPLACE ALL OCCURRENCES OF '°' IN lv_xmldata WITH '&#176;'.
*    REPLACE ALL OCCURRENCES OF '±' IN lv_xmldata WITH '&#177;'.
*    REPLACE ALL OCCURRENCES OF '²' IN lv_xmldata WITH '&#178;'.
*    REPLACE ALL OCCURRENCES OF '³' IN lv_xmldata WITH '&#179;'.
*    REPLACE ALL OCCURRENCES OF '´' IN lv_xmldata WITH '&#180;'.
*    REPLACE ALL OCCURRENCES OF 'µ' IN lv_xmldata WITH '&#181;'.
*    REPLACE ALL OCCURRENCES OF '¶' IN lv_xmldata WITH '&#182;'.
*    REPLACE ALL OCCURRENCES OF '·' IN lv_xmldata WITH '&#183;'.
*    REPLACE ALL OCCURRENCES OF '¸' IN lv_xmldata WITH '&#184;'.
*    REPLACE ALL OCCURRENCES OF '¹' IN lv_xmldata WITH '&#185;'.
*    REPLACE ALL OCCURRENCES OF 'º' IN lv_xmldata WITH '&#186;'.
*    REPLACE ALL OCCURRENCES OF '»' IN lv_xmldata WITH '&#187;'.
*    REPLACE ALL OCCURRENCES OF '¼' IN lv_xmldata WITH '&#188;'.
*    REPLACE ALL OCCURRENCES OF '½' IN lv_xmldata WITH '&#189;'.
*    REPLACE ALL OCCURRENCES OF '¾' IN lv_xmldata WITH '&#190;'.
*    REPLACE ALL OCCURRENCES OF '¿' IN lv_xmldata WITH '&#191;'.
*    REPLACE ALL OCCURRENCES OF 'À' IN lv_xmldata WITH '&#192;'.
*    REPLACE ALL OCCURRENCES OF 'Á' IN lv_xmldata WITH '&#193;'.
*    REPLACE ALL OCCURRENCES OF 'Â' IN lv_xmldata WITH '&#194;'.
*    REPLACE ALL OCCURRENCES OF 'Ã' IN lv_xmldata WITH '&#195;'.
*    REPLACE ALL OCCURRENCES OF 'Ä' IN lv_xmldata WITH '&#196;'.
*    REPLACE ALL OCCURRENCES OF 'Å' IN lv_xmldata WITH '&#197;'.
*    REPLACE ALL OCCURRENCES OF 'Æ' IN lv_xmldata WITH '&#198;'.
*    REPLACE ALL OCCURRENCES OF 'Ç' IN lv_xmldata WITH '&#199;'.
*    REPLACE ALL OCCURRENCES OF 'È' IN lv_xmldata WITH '&#200;'.
*    REPLACE ALL OCCURRENCES OF 'É' IN lv_xmldata WITH '&#201;'.
*    REPLACE ALL OCCURRENCES OF 'Ê' IN lv_xmldata WITH '&#202;'.
*    REPLACE ALL OCCURRENCES OF 'Ë' IN lv_xmldata WITH '&#203;'.
*    REPLACE ALL OCCURRENCES OF 'Ì' IN lv_xmldata WITH '&#204;'.
*    REPLACE ALL OCCURRENCES OF 'Í' IN lv_xmldata WITH '&#205;'.
*    REPLACE ALL OCCURRENCES OF 'Î' IN lv_xmldata WITH '&#206;'.
*    REPLACE ALL OCCURRENCES OF 'Ï' IN lv_xmldata WITH '&#207;'.
*    REPLACE ALL OCCURRENCES OF 'Ð' IN lv_xmldata WITH '&#208;'.
*    REPLACE ALL OCCURRENCES OF 'Ñ' IN lv_xmldata WITH '&#209;'.
*    REPLACE ALL OCCURRENCES OF 'Ò' IN lv_xmldata WITH '&#210;'.
*    REPLACE ALL OCCURRENCES OF 'Ó' IN lv_xmldata WITH '&#211;'.
*    REPLACE ALL OCCURRENCES OF 'Ô' IN lv_xmldata WITH '&#212;'.
*    REPLACE ALL OCCURRENCES OF 'Õ' IN lv_xmldata WITH '&#213;'.
*    REPLACE ALL OCCURRENCES OF 'Ö' IN lv_xmldata WITH '&#214;'.
*    REPLACE ALL OCCURRENCES OF '×' IN lv_xmldata WITH '&#215;'.
*    REPLACE ALL OCCURRENCES OF 'Ø' IN lv_xmldata WITH '&#216;'.
*    REPLACE ALL OCCURRENCES OF 'Ù' IN lv_xmldata WITH '&#217;'.
*    REPLACE ALL OCCURRENCES OF 'Ú' IN lv_xmldata WITH '&#218;'.
*    REPLACE ALL OCCURRENCES OF 'Û' IN lv_xmldata WITH '&#219;'.
*    REPLACE ALL OCCURRENCES OF 'Ü' IN lv_xmldata WITH '&#220;'.
*    REPLACE ALL OCCURRENCES OF 'Ý' IN lv_xmldata WITH '&#221;'.
*    REPLACE ALL OCCURRENCES OF 'Þ' IN lv_xmldata WITH '&#222;'.
*    REPLACE ALL OCCURRENCES OF 'ß' IN lv_xmldata WITH '&#223;'.
*    REPLACE ALL OCCURRENCES OF 'à' IN lv_xmldata WITH '&#224;'.
*    REPLACE ALL OCCURRENCES OF 'á' IN lv_xmldata WITH '&#225;'.
*    REPLACE ALL OCCURRENCES OF 'â' IN lv_xmldata WITH '&#226;'.
*    REPLACE ALL OCCURRENCES OF 'ã' IN lv_xmldata WITH '&#227;'.
*    REPLACE ALL OCCURRENCES OF 'ä' IN lv_xmldata WITH '&#228;'.
*    REPLACE ALL OCCURRENCES OF 'å' IN lv_xmldata WITH '&#229;'.
*    REPLACE ALL OCCURRENCES OF 'æ' IN lv_xmldata WITH '&#230;'.
*    REPLACE ALL OCCURRENCES OF 'ç' IN lv_xmldata WITH '&#231;'.
*    REPLACE ALL OCCURRENCES OF 'è' IN lv_xmldata WITH '&#232;'.
*    REPLACE ALL OCCURRENCES OF 'é' IN lv_xmldata WITH '&#233;'.
*    REPLACE ALL OCCURRENCES OF 'ê' IN lv_xmldata WITH '&#234;'.
*    REPLACE ALL OCCURRENCES OF 'ë' IN lv_xmldata WITH '&#235;'.
*    REPLACE ALL OCCURRENCES OF 'ì' IN lv_xmldata WITH '&#236;'.
*    REPLACE ALL OCCURRENCES OF 'í' IN lv_xmldata WITH '&#237;'.
*    REPLACE ALL OCCURRENCES OF 'î' IN lv_xmldata WITH '&#238;'.
*    REPLACE ALL OCCURRENCES OF 'ï' IN lv_xmldata WITH '&#239;'.
*    REPLACE ALL OCCURRENCES OF 'ð' IN lv_xmldata WITH '&#240;'.
*    REPLACE ALL OCCURRENCES OF 'ñ' IN lv_xmldata WITH '&#241;'.
*    REPLACE ALL OCCURRENCES OF 'ò' IN lv_xmldata WITH '&#242;'.
*    REPLACE ALL OCCURRENCES OF 'ó' IN lv_xmldata WITH '&#243;'.
*    REPLACE ALL OCCURRENCES OF 'ô' IN lv_xmldata WITH '&#244;'.
*    REPLACE ALL OCCURRENCES OF 'õ' IN lv_xmldata WITH '&#245;'.
*    REPLACE ALL OCCURRENCES OF 'ö' IN lv_xmldata WITH '&#246;'.
*    REPLACE ALL OCCURRENCES OF '÷' IN lv_xmldata WITH '&#247;'.
*    REPLACE ALL OCCURRENCES OF 'ø' IN lv_xmldata WITH '&#248;'.
*    REPLACE ALL OCCURRENCES OF 'ù' IN lv_xmldata WITH '&#249;'.
*    REPLACE ALL OCCURRENCES OF 'ú' IN lv_xmldata WITH '&#250;'.
*    REPLACE ALL OCCURRENCES OF 'û' IN lv_xmldata WITH '&#251;'.
*    REPLACE ALL OCCURRENCES OF 'ü' IN lv_xmldata WITH '&#252;'.
*    REPLACE ALL OCCURRENCES OF '✓' IN lv_xmldata WITH 'a'.
*    REPLACE ALL OCCURRENCES OF 'ý' IN lv_xmldata WITH '&#253;'.

    SELECT SINGLE *
        FROM zdt_adobe_store
        WHERE upper( formtemplate ) = @( to_upper( iv_form_name ) )
        INTO @DATA(ls_form) .

    IF ls_form IS INITIAL OR ls_form-attachment IS INITIAL.
      ev_status = 'E'.
      rv_result = 'ERROR: XDP template not found or empty for: ' && iv_form_name.
      RETURN.
    ENDIF.

    IF lv_xmldata IS INITIAL.
      ev_status = 'E'.
      rv_result = 'ERROR: XML input data is empty'.
      RETURN.
    ENDIF.

    DATA(lv_xml_xstring) = cl_abap_conv_codepage=>create_out( codepage = 'UTF-8' )->convert( lv_xmldata ).

    TRY.
        cl_fp_ads_util=>render_pdf(
          EXPORTING
            iv_xml_data     = lv_xml_xstring
            iv_xdp_layout   = ls_form-attachment
            iv_locale       = 'en_US'
          IMPORTING
            ev_pdf          = ev_pdf
            ev_pages        = ev_pages
            ev_trace_string = ev_trace_string ).

      CATCH cx_fp_ads_util INTO DATA(lx_fp_ads_util).
        ev_status = 'E'.
        rv_result = lx_fp_ads_util->get_text( ) && | | && ev_trace_string.
        RETURN.
    ENDTRY.
    ev_status = 'S'.
    rv_result = xco_cp=>xstring( ev_pdf )->as_string( xco_cp_binary=>text_encoding->base64 )->value .
  ENDMETHOD .
ENDCLASS.
