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
     -- RETURN ('� ' || inInvNumber || ' o� '|| DATE (inOperDate) :: TVarChar || COALESCE ((SELECT ' <' || CASE WHEN inDescId = -1 * zc_Movement_ProductionUnion() THEN '�����������' ELSE ItemName END || '>' FROM MovementDesc WHERE Id = ABS (inDescId)), ''));
     RETURN ('� <'   || CASE WHEN inInvNumber <> '' THEN inInvNumber ELSE '0' END || '>'
          || ' o� <' || CASE WHEN inOperDate > zc_DateStart() THEN zfConvert_DateToString (inOperDate) ELSE '' END || '>'
            );

END;
$BODY$
  LANGUAGE PLPGSQL IMMUTABLE;
ALTER FUNCTION zfCalc_PartionMovementName (Integer, TVarChar, TVarChar, TDateTime) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 31.01.18                                        *
*/

-- ����
-- SELECT * FROM zfCalc_PartionMovementName (zc_Movement_Sale(), 'zc_Movement_Sale', '123', CURRENT_DATE)
