-- Function: gpSelect_ShowPUSH_IncomeNewPretension(TVarChar)

DROP FUNCTION IF EXISTS gpSelect_ShowPUSH_IncomeNewPretension(integer,VarChar);

CREATE OR REPLACE FUNCTION gpSelect_ShowPUSH_IncomeNewPretension(
    IN inMovementID   integer,          -- ������
   OUT outShowMessage Boolean,          -- ��������� ���������
   OUT outPUSHType    Integer,          -- ��� ���������
   OUT outText        Text,             -- ����� ���������
    IN inSession      TVarChar          -- ������ ������������
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbText  Text;
BEGIN

    outShowMessage := False;

    IF EXISTS(SELECT  1
              FROM MovementLinkMovement AS MLMovement_Income
              
                   INNER JOIN Movement ON Movement.Id = MLMovement_Income.MovementId
                                      AND Movement.DescId = zc_Movement_Pretension()
                                      AND Movement.StatusId = zc_Enum_Status_UnComplete() 
              
              WHERE MLMovement_Income.MovementChildId = inMovementID
                AND MLMovement_Income.DescId = zc_MovementLinkMovement_Income())
    THEN
    
      WITH tmpMovement AS (SELECT Movement.Id
                                , '� '||Movement.InvNumber||' �� '||to_char(Movement.OperDate, 'DD.MM.YYYY') AS Pretension
                           FROM MovementLinkMovement AS MLMovement_Income
                            
                                INNER JOIN Movement ON Movement.Id = MLMovement_Income.MovementId
                                                   AND Movement.DescId = zc_Movement_Pretension()
                                                   AND Movement.StatusId = zc_Enum_Status_UnComplete() 
                            
                           WHERE MLMovement_Income.MovementChildId = inMovementID
                             AND MLMovement_Income.DescId = zc_MovementLinkMovement_Income()
                          )
                          
      SELECT string_agg(Pretension||chr(13), chr(13))
      INTO vbText
      FROM tmpMovement
      ;  

      IF COALESCE (vbText, '') <> ''
      THEN
        outShowMessage := True;
        outPUSHType := zc_TypePUSH_Confirmation();
        outText := '�������� !!!'||chr(13)||chr(13)||'�� ������ ��������� ��������� ��� ���� ����� ������� ���������'||chr(13)||vbText||chr(13)||chr(13)||
                   '��������� �� ������������!';
      END IF;
    END IF;


END;
$BODY$

LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 21.12.21                                                       *

*/

-- 
SELECT * FROM gpSelect_ShowPUSH_IncomeNewPretension(26110310, '3')