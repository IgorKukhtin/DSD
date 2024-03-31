-- Function: zfCalc_PartionMovementName

DROP FUNCTION IF EXISTS zfCalc_PartionMovementName (Integer, TVarChar, TVarChar, TDateTime);

CREATE OR REPLACE FUNCTION zfCalc_PartionMovementName(
    IN inDescId                    Integer,  -- 
    IN inItemName                  TVarChar, -- 
    IN inInvNumber                 TVarChar, -- 
    IN inOperDate                  TDateTime -- 
)
RETURNS TVarChar AS
$BODY$
BEGIN
     -- ���������� ���������
     RETURN TRIM (CASE WHEN inDescId = zc_Movement_BankSecondNum() THEN '' ELSE '� ' END
               || inInvNumber -- CASE WHEN inInvNumber <> '' AND inInvNumber <> '0' THEN '� ' || inInvNumber ELSE '' END
               || ' o� '|| zfConvert_DateToString (inOperDate)
               || COALESCE ((SELECT ' <' || CASE WHEN inDescId = -1 * zc_Movement_ProductionUnion()
                                                      THEN '�����������'
                                                 ELSE ItemName
                                            END
                                         || '>'
                             FROM MovementDesc WHERE Id = ABS (inDescId)
                            ), '')
                 );

END;
$BODY$
  LANGUAGE PLPGSQL IMMUTABLE;
ALTER FUNCTION zfCalc_PartionMovementName (Integer, TVarChar, TVarChar, TDateTime) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 30.04.15                                        *
*/

-- ����
-- SELECT * FROM zfCalc_PartionMovementName (zc_Movement_Sale(), 'zc_Movement_Sale', '123', CURRENT_DATE)
