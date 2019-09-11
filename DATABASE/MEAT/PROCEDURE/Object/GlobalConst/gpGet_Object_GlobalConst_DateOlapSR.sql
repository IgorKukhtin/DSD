-- Function: gpGet_Object_GlobalConst_DateOlapSR

DROP FUNCTION IF EXISTS gpGet_Object_GlobalConst_DateOlapSR (TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_GlobalConst_DateOlapSR (
    IN inSession TVarChar
)
RETURNS TABLE (ProtocolDateOlapSR  TDateTime  --���� ������������ ������ ���� �������/�������
             , EndDateOlapSR       TDateTime  --�� ����� ���� ������������ ������������ ������ ���� �������/�������
              )
AS $BODY$
  DECLARE vbUserId Integer;
  DECLARE vbProtocolDateOlapSR TDateTime;
  DECLARE vbEndDateOlapSR TDateTime;
BEGIN
      -- �������� ���� ������������ �� ����� ���������
      -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_...());
      vbUserId:= lpGetUserBySession (inSession);

      -- ���� ������������ ������ ���� �������/�������
      SELECT ObjectDate_ActualBankStatement.ValueData 
     INTO  vbProtocolDateOlapSR
      FROM  ObjectDate AS ObjectDate_ActualBankStatement
      WHERE ObjectDate_ActualBankStatement.ObjectId = zc_Enum_GlobalConst_ProtocolDateOlapSR()
        AND ObjectDate_ActualBankStatement.DescId = zc_ObjectDate_GlobalConst_ActualBankStatement();
      
      -- �� ����� ���� ������������ ������������ ������ ���� �������/�������
      SELECT ObjectDate_ActualBankStatement.ValueData
     INTO vbEndDateOlapSR
      FROM  ObjectDate AS ObjectDate_ActualBankStatement
      WHERE ObjectDate_ActualBankStatement.ObjectId = zc_Enum_GlobalConst_EndDateOlapSR()
        AND ObjectDate_ActualBankStatement.DescId = zc_ObjectDate_GlobalConst_ActualBankStatement();
      
      -- ���������
      RETURN QUERY
        SELECT vbProtocolDateOlapSR ::TDateTime
             , vbEndDateOlapSR
        ;

END; $BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 10.09.19         *
*/

-- ����
-- SELECT * FROM gpGet_Object_GlobalConst_DateOlapSR (inSession:= zfCalc_UserAdmin());
