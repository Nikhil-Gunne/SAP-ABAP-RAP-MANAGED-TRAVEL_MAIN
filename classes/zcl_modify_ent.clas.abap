CLASS zcl_modify_ent DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_modify_ent IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.

**********************************************************************
    "MODIFY CAN BE USED WITH
    "CREATE
    "CREATE BY
    "UPDATE
    "DELETE -> if parent is deleted the child entities are deleted automatically due to composition
**********************************************************************
*MODIFY ENTITY SHORT FORM WITH CREATE
**********************************************************************
*    MODIFY ENTITY zi_nik_travel_m
*    CREATE
*    FROM VALUE #( ( %cid = 'TID1'
*                    AgencyId = '1'
*                    %control-AgencyId = if_abap_behv=>mk-on
*                    ) )
*    FAILED FINAL(lt_failed)
*    MAPPED DATA(lt_mapped)
*    REPORTED DATA(lt_reported).
*    IF lt_failed IS NOT INITIAL.
*      out->write( lt_failed ).
*    ELSE.
*      COMMIT ENTITIES.
*      out->write( | succesffully created a travel id | ).
*    ENDIF.
*    MODIFY ENTITY zi_nik_travel_m
*  CREATE BY \_booking
*  FIELDS ( BookingDate CustomerId )
*  WITH VALUE #(
*    (
*      TravelId = '4241'
*      %target = VALUE #(
*        (
*          %cid        = 'BID1'
*          BookingDate = '20260703'
*          CustomerId  = '1'
*        )
*      )
*    )
*  )
*  FAILED   DATA(lt_f)
*  MAPPED   DATA(lt_m)
*  REPORTED DATA(lt_r).

*IF lt_f IS INITIAL.
*  COMMIT ENTITIES.
*  out->write( |Successfully created Booking by association.| ).
*ENDIF.


  ENDMETHOD.

ENDCLASS.
