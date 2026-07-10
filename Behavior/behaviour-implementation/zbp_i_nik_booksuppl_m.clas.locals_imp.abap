CLASS lhc_zi_nik_booksuppl_m DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS determineTotalPrice FOR DETERMINE ON MODIFY
      IMPORTING keys FOR ZI_NIK_BOOKSUPPL_M~determineTotalPrice.

ENDCLASS.

CLASS lhc_zi_nik_booksuppl_m IMPLEMENTATION.

  METHOD determineTotalPrice.
  DATA: it_travel TYPE STANDARD TABLE OF zi_nik_travel_m  WITH UNIQUE HASHED KEY key COMPONENTS TravelId.

    it_travel =  CORRESPONDING #(  keys DISCARDING DUPLICATES MAPPING TravelId = TravelId ).
    MODIFY ENTITIES OF zi_nik_travel_m  IN LOCAL MODE
     ENTITY zi_nik_travel_m
     EXECUTE reCalcTotalPrice
     FROM CORRESPONDING #( it_travel ).
*  MODIFY ENTITIES OF zi_nik_travel_m in LOCAL mode
*  ENTITY zi_nik_travel_m
*  EXECUTE reCalcTotalPrice
*  FROM CORRESPONDING #( keys ).

  ENDMETHOD.

ENDCLASS.

*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations

