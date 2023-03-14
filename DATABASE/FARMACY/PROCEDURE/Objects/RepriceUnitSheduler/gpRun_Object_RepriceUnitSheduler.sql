-- Function: gpRun_Object_RepriceUnitSheduler()

DROP FUNCTION IF EXISTS gpRun_Object_RepriceUnitSheduler(Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpRun_Object_RepriceUnitSheduler(
    IN InJuridicalID Integer,
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS VOID AS
$BODY$
   DECLARE vbMovPromoBonus Integer;
   DECLARE text_var1 Text;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_ImportType());
   
  IF date_part('isodow', CURRENT_DATE)::Integer in (6, 7)
  THEN
    RETURN;
  END IF;

    -- ����������
  PERFORM  gpRun_Object_RepriceUnitSheduler_UnitReprice(Object_RepriceUnitSheduler.Id, 
                                                        COALESCE (ObjectLink_User.ChildObjectId::TVarChar, inSession))
  FROM Object AS Object_RepriceUnitSheduler

           INNER JOIN ObjectLink AS ObjectLink_Unit
                                 ON ObjectLink_Unit.ObjectId = Object_RepriceUnitSheduler.Id
                                AND ObjectLink_Unit.DescId = zc_ObjectLink_RepriceUnitSheduler_Unit()

           INNER JOIN ObjectLink AS ObjectLink_Unit_Juridical
                                 ON ObjectLink_Unit_Juridical.ObjectId = ObjectLink_Unit.ChildObjectId
                                AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()  

           LEFT JOIN ObjectLink AS ObjectLink_User
                                 ON ObjectLink_User.ObjectId = Object_RepriceUnitSheduler.Id
                                AND ObjectLink_User.DescId = zc_ObjectLink_RepriceUnitSheduler_User()

  WHERE Object_RepriceUnitSheduler.DescId = zc_Object_RepriceUnitSheduler()
    AND Object_RepriceUnitSheduler.isErased = FALSE
    AND (ObjectLink_Unit_Juridical.ChildObjectId = InJuridicalID OR InJuridicalID = 0);
    

    -- �����������
  PERFORM  gpRun_Object_RepriceUnitSheduler_UnitEqual(Object_RepriceUnitSheduler.Id, 
                                                      ObjectLink_Unit_UnitRePrice.ChildObjectId, 
                                                      COALESCE (ObjectLink_User.ChildObjectId::TVarChar, inSession))
  FROM Object AS Object_RepriceUnitSheduler

           INNER JOIN ObjectLink AS ObjectLink_Unit
                                 ON ObjectLink_Unit.ObjectId = Object_RepriceUnitSheduler.Id
                                AND ObjectLink_Unit.DescId = zc_ObjectLink_RepriceUnitSheduler_Unit()

           INNER JOIN ObjectLink AS ObjectLink_Unit_Juridical
                                 ON ObjectLink_Unit_Juridical.ObjectId = ObjectLink_Unit.ChildObjectId
                                AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()  

           INNER JOIN ObjectBoolean AS ObjectBoolean_Equal
                                   ON ObjectBoolean_Equal.ObjectId = Object_RepriceUnitSheduler.Id
                                  AND ObjectBoolean_Equal.DescId = zc_ObjectBoolean_RepriceUnitSheduler_Equal()
                                  AND ObjectBoolean_Equal.ValueData = TRUE

           LEFT JOIN ObjectLink AS ObjectLink_Unit_UnitRePrice
                                 ON ObjectLink_Unit_UnitRePrice.ObjectId = ObjectLink_Unit.ChildObjectId
                                AND ObjectLink_Unit_UnitRePrice.DescId = zc_ObjectLink_Unit_UnitRePrice()

           LEFT JOIN ObjectLink AS ObjectLink_User
                                 ON ObjectLink_User.ObjectId = Object_RepriceUnitSheduler.Id
                                AND ObjectLink_User.DescId = zc_ObjectLink_RepriceUnitSheduler_User()

  WHERE Object_RepriceUnitSheduler.DescId = zc_Object_RepriceUnitSheduler()
    AND Object_RepriceUnitSheduler.isErased = FALSE
    AND (ObjectLink_Unit_Juridical.ChildObjectId = InJuridicalID OR InJuridicalID = 0);
    
    
    -- ���������� ��� �����
  BEGIN
    PERFORM * FROM gpRun_Object_RepriceSheduler_RepriceSite (inSession);
  EXCEPTION
     WHEN others THEN
       GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT;
     PERFORM lpLog_Run_Schedule_Function('gpRun_Object_RepriceSheduler_RepriceSite', True, text_var1::TVarChar, vbUserId);
  END;

    -- ���������� ��� �����
  BEGIN
    vbMovPromoBonus := (WITH tmpMovPromoBonus AS 
                             (SELECT Movement.id AS ID FROM Movement
                              WHERE Movement.OperDate <= CURRENT_DATE
                                AND Movement.DescId = zc_Movement_PromoBonus()
                                AND Movement.StatusId = zc_Enum_Status_Complete()
                              )
       							 
                       SELECT MAX(tmpMovPromoBonus.ID) AS ID FROM tmpMovPromoBonus);
                       
    IF COALESCE (vbMovPromoBonus, 0) <> 0
    THEN
      PERFORM * FROM gpInsertUpdate_PromoBonus_MarginPercent(inMovementId := vbMovPromoBonus,  inSession := '3');
    END IF;
  EXCEPTION
     WHEN others THEN
       GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT;
     PERFORM lpLog_Run_Schedule_Function('gpInsertUpdate_PromoBonus_MarginPercent', True, text_var1::TVarChar, vbUserId);
  END;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpRun_Object_RepriceUnitSheduler(Integer, TVarChar) OWNER TO postgres;

-------------------------------------------------------------------------------
/*
 ������� ����������: ����, �����
               ������ �.�.
 22.10.18        *
*/

-- ����
-- SELECT * FROM gpRun_Object_RepriceUnitSheduler (0, '3')