CLASS zcx_xdp_query_error DEFINITION
  PUBLIC
  INHERITING FROM cx_rap_query_provider
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.

    DATA mv_long_text TYPE string.      " add this

    METHODS constructor
      IMPORTING
        previous LIKE previous OPTIONAL
        iv_msgid TYPE symsgid OPTIONAL  " make optional for long text case
        iv_msgno TYPE symsgno OPTIONAL
        iv_msgv1 TYPE symsgv  OPTIONAL
        iv_msgv2 TYPE symsgv  OPTIONAL
        iv_msgv3 TYPE symsgv  OPTIONAL
        iv_msgv4 TYPE symsgv  OPTIONAL
        iv_long_text TYPE string OPTIONAL.  " add this

    METHODS get_text REDEFINITION.      " add this

ENDCLASS.



CLASS ZCX_XDP_QUERY_ERROR IMPLEMENTATION.


  METHOD constructor ##ADT_SUPPRESS_GENERATION.
    super->constructor( previous = previous ).

    if_t100_message~t100key = VALUE #(
      msgid = iv_msgid
      msgno = iv_msgno
      attr1 = 'IF_T100_DYN_MSG~MSGV1'
      attr2 = 'IF_T100_DYN_MSG~MSGV2'
      attr3 = 'IF_T100_DYN_MSG~MSGV3'
      attr4 = 'IF_T100_DYN_MSG~MSGV4'
    ).

    if_t100_dyn_msg~msgv1 = iv_msgv1.
    if_t100_dyn_msg~msgv2 = iv_msgv2.
    if_t100_dyn_msg~msgv3 = iv_msgv3.
    if_t100_dyn_msg~msgv4 = iv_msgv4.

    mv_long_text = iv_long_text.        " store full string

  ENDMETHOD.


  METHOD get_text.
    IF mv_long_text IS NOT INITIAL.
      result = mv_long_text.            " return full ADS error, no truncation
    ELSE.
      result = super->get_text( ).      " fallback to normal T100 message
    ENDIF.
  ENDMETHOD.
ENDCLASS.
