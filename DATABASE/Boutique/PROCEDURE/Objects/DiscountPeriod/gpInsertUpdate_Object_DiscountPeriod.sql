-- �������� ������������� ������

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_DiscountPeriod (Integer, Integer, Integer, Integer, TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_DiscountPeriod(
 INOUT ioId             Integer,       -- ���� ������� <�������� ������������� ������>            
 INOUT ioCode           Integer,       -- ��� ������� <�������� ������������� ������>             
    IN inUnitId         Integer,       -- ���� ������� <>
    IN inPeriodId       Integer,       -- ���� ������� <>
    IN inStartDate      TDateTime ,
    IN inEndDate        TDateTime ,
    IN inSession        TVarChar       -- ������ ������������                     
)
RETURNS RECORD
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN

   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_DiscountPeriod());
   vbUserId:= lpGetUserBySession (inSession);

   -- ����� ������- ��� ����� ����� � ioCode -> ioCode
   IF COALESCE (ioId, 0) = 0 AND COALESCE (ioCode, 0) <> 0 THEN ioCode := NEXTVAL ('Object_DiscountPeriod_seq'); 

   -- �������� - ��� Sybase ������ Id
   ELSEIF vbUserId = zc_User_Sybase() AND COALESCE (ioId, 0) = 0
          THEN ioCode := NEXTVAL ('Object_DiscountPeriod_seq'); 
   ELSEIF vbUserId = zc_User_Sybase()
          THEN ioCode := COALESCE ((SELECT ObjectCode FROM Object WHERE Id = ioId), 0);
   END IF; 

   -- �������� ������������ ��� �������� <���>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_DiscountPeriod(), ioCode);


   -- ��������
   IF EXISTS (SELECT
              FROM gpSelect_Object_DiscountPeriod (inIsShowAll:= TRUE, inSession:= inSession) AS tmp
              WHERE tmp.Id                     <> COALESCE (ioId, 0)
                AND COALESCE (tmp.UnitId, 0)    = COALESCE (inUnitId, 0)
                AND COALESCE (tmp.PeriodId, 0)  = COALESCE (inPeriodId, 0)
                AND (tmp.YEAR_Start             = EXTRACT (YEAR FROM inStartDate)
                  OR tmp.YEAR_End               = EXTRACT (YEAR FROM inEndDate)
                    )
             )
   THEN
       RAISE EXCEPTION '������.������ ��� ���������� ��� ������ <% : % - %>  <%>.', lfGet_Object_ValueData_sh (inPeriodId), EXTRACT (YEAR FROM inStartDate), EXTRACT (YEAR FROM inEndDate), lfGet_Object_ValueData_sh (inUnitId);
   END IF;


   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_DiscountPeriod(), ioCode, '');
  
   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_DiscountPeriod_Unit(), ioId, inUnitId);
   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_DiscountPeriod_Period(), ioId, inPeriodId);

   -- ��������� <>
   PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_DiscountPeriod_StartDate(), ioId, inStartDate);
   -- ��������� <>
   PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_DiscountPeriod_EndDate(), ioId, inEndDate);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$

LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
23.02.18          *
*/

-- ����
-- 