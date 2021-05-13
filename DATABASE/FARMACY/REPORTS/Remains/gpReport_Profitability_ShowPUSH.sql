-- Function: gpReport_Profitability_ShowPUSH(TVarChar)

DROP FUNCTION IF EXISTS gpReport_Profitability_ShowPUSH(TDateTime,TDateTime,TVarChar);

CREATE OR REPLACE FUNCTION gpReport_Profitability_ShowPUSH(
    IN inDateStart              TDateTime,  -- ���� ������
    IN inDateFinal              TDateTime,  -- ���� �����
   OUT outShowMessage           Boolean,    -- ��������� ���������
   OUT outPUSHType              Integer,    -- ��� ���������
   OUT outText                  Text,       -- ����� ���������
    IN inSession                TVarChar    -- ������ ������������
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbName  TVarChar;
   DECLARE vbJuridical Integer;
BEGIN

    outShowMessage := False;

    outText := '';
    
    IF NOT EXISTS(SELECT 1
                  FROM AnalysisContainerItem AS ContainerItem
                  WHERE ContainerItem.Operdate = inDateFinal
                    AND ContainerItem.UnitId <> 0
                  LIMIT 1)
       AND DATE_TRUNC ('day', inDateFinal) >= CURRENT_DATE
    THEN
      outText := '�� ����� ������� �� ������������ ������������� ������� ������ �� ����������.'||CHR(13)||'���������� �����.';    
    END IF;
    
    IF DATE_TRUNC ('month', inDateFinal) + INTERVAL '1 MONTH' - INTERVAL  '1 DAY' <> DATE_TRUNC ('day', inDateFinal) OR
       DATE_TRUNC ('month', inDateStart) <> DATE_TRUNC ('day', inDateStart)
    THEN
      IF COALESCE(outText, '') <> ''
      THEN
        outText := outText||CHR(13)||CHR(13);
      ELSE  
        outText := '';
      END IF;
      outText := outText||'������ �� ������� ������.';    
    END IF;

    IF COALESCE(outText, '') <> ''
    THEN
      outShowMessage := True;
      outPUSHType := 3;
      outText := outText;
     END IF;


END;
$BODY$

LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 13.05.21                                                       *

*/

-- SELECT * FROM gpSelect_ShowPUSH_OrderInternal(183292,'3')

select * from gpReport_Profitability_ShowPUSH(inDateStart := ('02.05.2021')::TDateTime , inDateFinal := ('13.05.2021')::TDateTime  ,  inSession := '3');
