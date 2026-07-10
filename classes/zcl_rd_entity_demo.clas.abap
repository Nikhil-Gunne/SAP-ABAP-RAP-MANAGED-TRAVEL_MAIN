CLASS zcl_rd_entity_demo DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
  INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_rd_entity_demo IMPLEMENTATION.

METHOD if_oo_adt_classrun~main.
**********************************************************************
*read single entity with multiple instances and getting values of fields with control flag.
**********************************************************************
*    READ ENTITY zi_nik_travel_m
*    FROM VALUE #( ( %key-TravelId = '00000001'
*                    %control = VALUE #( AgencyId = 01
*                                        BeginDate = 01
*                                        CustomerId = if_abap_behv=>mk-on ) )
*                    ( %key-TravelId = '00000003'
*                    %control = VALUE #( AgencyId = 01
*                                        TotalPrice = 01
*                                        CustomerId = if_abap_behv=>mk-on ) )
* )
*    RESULT DATA(lt_travel)
*    FAILED DATA(lt_failed).
*    IF lt_failed IS NOT INITIAL.
*      out->write( lt_failed ).
*    ELSE.
*      out->write( lt_travel ).
*    ENDIF.
**********************************************************************
  " another type of read entity with fields mentioned separately without %control
**********************************************************************
*    READ ENTITY zi_nik_travel_m
*    FIELDS ( AgencyId CustomerId BeginDate CurrencyCode TotalPrice )
*    WITH
*    VALUE #( ( %key-TravelId = '00000001' ) )
*    RESULT DATA(lt_travel1)
*    FAILED DATA(lt_failed1).
*    if lt_failed1 is not INITIAL.
*    out->write( lt_failed1 ).
*    else.
*    out->write( lt_travel1 ).
*    endif.

**********************************************************************
  " read entity with all fields
**********************************************************************
*    READ ENTITY zi_nik_travel_m
*    all FIELDS
*    WITH
*    VALUE #( ( %key-TravelId = '00000001' )
*              ( %key-TravelId = '00000290' )
*              )
*    RESULT DATA(lt_travel2)
*    FAILED DATA(lt_failed2).
*    if lt_failed2 is not INITIAL.
*    out->write( lt_failed2 ).
*    else.
*    out->write( lt_travel2 ).
*    endif.


**********************************************************************
*read entities long form
*reading multiple instances of multiple entities
**********************************************************************

  READ ENTITIES OF zi_nik_travel_m
  ENTITY zi_nik_travel_m
  FIELDS ( TravelId AgencyId CustomerId TotalPrice )
  WITH
  VALUE #( ( %key-TravelId = '00000001' )
           ( %key-TravelId = '00000290' ) )
  RESULT DATA(lt_travel_long)

  ENTITY zi_nik_booking_m
  FIELDS ( BookingId BookingStatus ConnectionId )
  WITH VALUE #( ( %key-TravelId = '00000001'  %key-BookingId = '1') )
  RESULT DATA(lt_booking_long)

  FAILED DATA(lt_failed_long).
  IF lt_failed_long IS NOT INITIAL.
    out->write( lt_failed_long ).
  ELSE.
    out->write( lt_travel_long ).
    out->write( lt_booking_long ).
  ENDIF.

**********************************************************************
" Read entities by association
**********************************************************************

*READ ENTITIES OF zi_nik_travel_m
*ENTITY zi_nik_travel_m BY \_booking
*ALL FIELDS
*WITH VALUE #( ( %key-TravelId = '00000001' )
*           ( %key-TravelId = '00000290' ) )
*RESULT DATA(lt_assoc_data)
*FAILED DATA(lt_failed_Assoc).
*
*IF lt_failed_assoc is not initial.
*out->write( lt_failed_assoc ).
*else.
*out->write( lt_assoc_data ).
*endif.




ENDMETHOD.
ENDCLASS.
