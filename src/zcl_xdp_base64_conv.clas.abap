CLASS zcl_xdp_base64_conv DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    TYPES: BEGIN OF ty_base64xdp,
             FormTemplate TYPE string,
             Base64Xdp    TYPE string,
           END OF ty_base64xdp.

    TYPES: BEGIN OF ty_base64pdf,
             FormTemplate TYPE string,
             xmldata      TYPE string,
             Base64pdf    TYPE string,
           END OF ty_base64pdf.

    TYPES: tt_base64xdp TYPE TABLE OF ty_base64xdp WITH EMPTY KEY.
    TYPES: tt_base64pdf TYPE TABLE OF ty_base64pdf WITH EMPTY KEY.

    DATA: gt_base64xdp TYPE tt_base64xdp,
          gt_base64pdf TYPE tt_base64pdf.

    INTERFACES: if_oo_adt_classrun,
      if_rap_query_provider.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_XDP_BASE64_CONV IMPLEMENTATION.


  METHOD if_rap_query_provider~select.

    DATA: lt_base64xdp TYPE tt_base64xdp,
          lt_base64pdf TYPE tt_base64pdf,
          lv_template  TYPE string.

    TRY.

        DATA(lv_entityid) = io_request->get_entity_id( ).

        CASE lv_entityid.
          WHEN 'ZCE_BASE64_FORM'.
            CLEAR: lv_template.

            DATA(lt_template) = io_request->get_filter( )->get_as_ranges( ).
            lv_template = VALUE #( lt_template[ name = 'FORMTEMPLATE' ]-range[ 1 ]-low OPTIONAL ).

            IF lv_template IS INITIAL.
              RAISE EXCEPTION TYPE zcx_xdp_query_error
                EXPORTING
                  iv_msgid = 'ZMSG_ADOBE'
                  iv_msgno = '001'.
            ENDIF.

            lt_base64xdp = zcl_adobe_generate=>base64_converter( iv_template = lv_template ).

            IF lt_base64xdp IS INITIAL.

              DATA(lv_msgv1) = CONV symsgv( lv_template ).
              CONDENSE lv_msgv1.

              RAISE EXCEPTION TYPE zcx_xdp_query_error
                EXPORTING
                  iv_msgid = 'ZMSG_ADOBE'
                  iv_msgno = '002'
                  iv_msgv1 = lv_msgv1.
            ENDIF.

            DATA(lv_skip_xdp) = io_request->get_paging( )->get_offset( ).
            DATA(lv_top_xdp)  = io_request->get_paging( )->get_page_size( ).
            IF lv_top_xdp < 0. lv_top_xdp = 1. ENDIF.

            CLEAR gt_base64xdp.
            APPEND LINES OF lt_base64xdp
              FROM lv_skip_xdp + 1
              TO   lv_skip_xdp + lv_top_xdp
              TO   gt_base64xdp.

            io_response->set_total_number_of_records( lines( lt_base64xdp ) ).
            io_response->set_data( gt_base64xdp ).

          WHEN 'ZCE_BASE64_PDF'.

            CLEAR: lv_template.
            DATA: lv_status TYPE c.
            DATA(lt_filter) = io_request->get_filter( )->get_as_ranges( ).
            lv_template = VALUE #( lt_filter[ name = 'FORMTEMPLATE' ]-range[ 1 ]-low OPTIONAL ).
            DATA(lv_xmldata) = VALUE #( lt_filter[ name = 'XMLDATA' ]-range[ 1 ]-low OPTIONAL ).

            IF lv_template IS INITIAL.
              RAISE EXCEPTION TYPE zcx_xdp_query_error
                EXPORTING
                  iv_msgid = 'ZMSG_PDF_GEN'
                  iv_msgno = '001'.
            ENDIF.

            IF lv_xmldata IS INITIAL.
              RAISE EXCEPTION TYPE zcx_xdp_query_error
                EXPORTING
                  iv_msgid = 'ZMSG_PDF_GEN'
                  iv_msgno = '002'.
            ENDIF.


            zcl_adobe_generate=>generate_pdf(
                EXPORTING
                    iv_form_name = lv_template
                    iv_xml = lv_xmldata
                IMPORTING
                    ev_status = lv_status
                RECEIVING
                    rv_result = DATA(lv_result)
            ).

            IF lv_status = 'E'.
              RAISE EXCEPTION TYPE zcx_xdp_query_error
                EXPORTING
                  iv_msgid     = 'ZMSG_PDF_GEN'
                  iv_msgno     = '003'
                  iv_msgv1     = CONV symsgv( lv_result )
                  iv_long_text = lv_result.
            ENDIF.

            APPEND VALUE #(
                FormTemplate = lv_template
                xmldata      = lv_xmldata
                Base64pdf    = lv_result
            ) TO lt_base64pdf.

            DATA(lv_skip_pdf) = io_request->get_paging( )->get_offset( ).
            DATA(lv_top_pdf)  = io_request->get_paging( )->get_page_size( ).
            IF lv_top_pdf < 0.
              lv_top_pdf = 1.
            ENDIF.

            CLEAR gt_base64pdf.
            APPEND LINES OF lt_base64pdf
              FROM lv_skip_pdf + 1
              TO   lv_skip_pdf + lv_top_pdf
              TO   gt_base64pdf.


            io_response->set_total_number_of_records( lines( lt_base64pdf ) ).
            io_response->set_data( gt_base64pdf ).

        ENDCASE.

      CATCH zcx_xdp_query_error INTO DATA(lx_custom).
        RAISE EXCEPTION lx_custom.

      CATCH cx_root INTO DATA(lx_root).
        RAISE EXCEPTION TYPE zcx_xdp_query_error
          EXPORTING
            iv_msgid = 'ZMSG_ADOBE'
            iv_msgno = '003'
            iv_msgv1 = CONV symsgv( lx_root->get_text( ) ).
    ENDTRY.
  ENDMETHOD.


  METHOD if_oo_adt_classrun~main.
    DATA(lt_data) = zcl_adobe_generate=>base64_converter( iv_template = 'PurchaseOrderForm' ).
    out->write( lt_data ).
  ENDMETHOD.
ENDCLASS.
