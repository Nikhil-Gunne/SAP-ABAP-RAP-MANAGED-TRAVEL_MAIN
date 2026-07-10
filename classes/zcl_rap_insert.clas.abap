CLASS zcl_rap_insert DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_rap_insert IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.


    DELETE FROM znik_travel_m.
    SELECT * FROM /dmo/travel_m
    INTO TABLE @DATA(lt_travels).
    IF sy-subrc = 0.
      INSERT znik_travel_m FROM TABLE @lt_travels.
      IF sy-subrc = 0.
        out->write( | successfully inserted data| ).
      ENDIF.
    ENDIF.



    DELETE FROM znik_booking_m.
    SELECT * FROM /dmo/booking_m
    INTO TABLE @DATA(lt_bookings).
    IF sy-subrc = 0.
      INSERT znik_booking_m FROM TABLE @lt_bookings.
      IF sy-subrc = 0.
        out->write( | successfully inserted data| ).
      ENDIF.
    ENDIF.

    DELETE FROM znik_booksuppl_m.
    SELECT * FROM /dmo/booksuppl_m
    INTO TABLE @DATA(lt_bookingsuppl).
    IF sy-subrc = 0.
      INSERT znik_booksuppl_m FROM TABLE @lt_bookingsuppl.
      IF sy-subrc = 0.
        out->write( | successfully inserted data| ).
      ENDIF.
    ENDIF.



  ENDMETHOD.
ENDCLASS.
