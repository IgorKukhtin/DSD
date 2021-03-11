-- Function:  gpReport_Check_SP_ForDPSS_Header()

DROP FUNCTION IF EXISTS gpReport_Check_SP_ForDPSS_Header (TDateTime, TDateTime, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_Check_SP_ForDPSS_Header(
    IN inStartDate        TDateTime,  -- ���� ������
    IN inEndDate          TDateTime,  -- ���� ���������
    IN inJuridicalId      Integer  ,  -- ��.����
    IN inSession          TVarChar    -- ������ ������������
)
RETURNS TABLE (Title            TBlob
)
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbcbname TVarChar;
   DECLARE vbjuridicaladdress TVarChar;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
    vbUserId:= lpGetUserBySession (inSession);
    
    IF inStartDate <> DATE_TRUNC ('DAY', inStartDate) OR
       inEndDate <> DATE_TRUNC ('DAY', inStartDate + INTERVAL '1 MONTH' - INTERVAL '1 DAY')
    THEN
        RAISE EXCEPTION '������.������ ������ ���� ������� ������.';
    END IF;
    
    SELECT cbname, juridicaladdress 
    INTO vbcbname, vbjuridicaladdress
    FROM gpSelect_Object_Juridical( inSession := '3') WHERE ID = inJuridicalId;
    
    -- ���������
    RETURN QUERY
      SELECT ('���������� �� '||zfCalc_MonthYearNameUkr (inStartDate)||
              ' ���� ���� ������������ ��������� ������������ ��� �� ������� ������, �� ������ ������ � ������� "������� ���", �� ��������� ������� '||
              COALESCE(vbcbname, '')::Text||','||COALESCE(vbjuridicaladdress, ''))::TBlob;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 09.03.21                                                       *
*/

-- ����
-- 
select * from gpReport_Check_SP_ForDPSS_Header(inStartDate := ('01.02.2021')::TDateTime , inEndDate := ('28.02.2021')::TDateTime , inJuridicalId := 2886776 , inSession := '3');