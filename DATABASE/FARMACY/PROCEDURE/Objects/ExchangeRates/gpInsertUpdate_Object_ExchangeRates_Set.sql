-- Function: gpInsertUpdate_Object_ExchangeRates()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ExchangeRates_Set(TDateTime, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_ExchangeRates_Set(
    IN inOperDate           TDateTime ,     -- ���� ������ ��������
    IN inExchange           TFloat    ,     -- ����
    IN inSession            TVarChar        -- ����������� ������ �� ��������� �����
)
  RETURNS integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;   
BEGIN
   -- �������� ���� ������������ �� ����� ���������
--    vbUserId:=lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_ExchangeRates());

   vbUserId := inSession::Integer;

   PERFORM gpInsertUpdate_Object_ExchangeRates(ioId         :=  COALESCE((SELECT tmp.Id FROM gpSelect_Object_ExchangeRates(False, zfCalc_UserAdmin()) AS tmp WHERE tmp.OperDate = inOperDate), 0)
                                             , inOperDate   := inOperDate
                                             , inExchange   := inExchange
                                             , inSession    := zfCalc_UserAdmin());
   
  -- RAISE EXCEPTION '<ok>';
   
END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------

 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 29.05.22                                                       *
*/

-- ����