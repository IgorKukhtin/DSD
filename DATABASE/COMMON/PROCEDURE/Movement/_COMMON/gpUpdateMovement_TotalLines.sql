-- Function: gpUpdateMovement_TotalLines()

DROP FUNCTION IF EXISTS gpUpdateMovement_TotalLines (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdateMovement_TotalLines(
    IN inId                  Integer   , -- ���� ������� <��������>
   OUT outTotalLines         TFloat   , -- 
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS TFloat 
AS
$BODY$
    DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     --vbUserId:= lpGetUserBySession (inSession);
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Update_Movement_TotalLines());

     --�� ��������� ������ ���������
     outTotalLines := (SELECT COUNT (*) AS TotalLines 
                       FROM MovementItem
                       WHERE MovementItem.MovementId = inId
                         AND MovementItem.DescId = zc_MI_Master()
                         AND MovementItem.isErased = FALSE
                       ) ::TFloat;

     -- ��������� ��������
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalLines(), inId, outTotalLines);

     -- ��������� ��������
     PERFORM lpInsert_MovementProtocol (inId, vbUserId, FALSE);
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 01.05.25         * 
*/


-- ����
--

/*

WITH
tmp AS (SELECT *
        FROM Movement
        WHERE Movement.DescId IN (zc_Movement_Sale()
                               , zc_Movement_ReturnIn()
                               , zc_Movement_SendOnPrice()
                               , zc_Movement_Income()
                               , zc_Movement_Inventory()
                               , zc_Movement_ReturnOut()
                               , zc_Movement_Send()
                               , zc_Movement_Loss()
                               )
          AND Movement.StatusId <> zc_Enum_Status_Erased() 
          AND Movement.OperDate BETWEEN '01.03.2025' AND '31.03.2025'
         )

SELECT gpUpdateMovement_TotalLines(tmp.Id, '9457')
--COUNT (*)
FROM tmp




SELECT DATE_TRUNC ('MONTH', Movement.OperDate) AS OperDate
, COUNT (DISTINCT Movement.DescId)
 , SUM (COALESCE (MovementFloat_TotalLines.ValueData,0)) AS TotalLines
        FROM Movement
            LEFT JOIN MovementFloat AS MovementFloat_TotalLines
                                    ON MovementFloat_TotalLines.MovementId = Movement.Id
                                   AND MovementFloat_TotalLines.DescId = zc_MovementFloat_TotalLines()
        WHERE Movement.DescId IN (zc_Movement_Sale()
                               , zc_Movement_ReturnIn()
                               , zc_Movement_SendOnPrice()
                               , zc_Movement_Income()
                               , zc_Movement_Inventory()
                               , zc_Movement_ReturnOut()
                               , zc_Movement_Send()
                               , zc_Movement_Loss()
                               )
          AND Movement.StatusId <> zc_Enum_Status_Erased() 
          AND Movement.OperDate BETWEEN '01.01.2024' AND '31.03.2026'
GROUP BY DATE_TRUNC ('MONTH', Movement.OperDate) 
order by 1

*/