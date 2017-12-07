-- Function: gpUnComplete_Movement_MarginCategory (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpUnComplete_Movement_MarginCategory (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUnComplete_Movement_MarginCategory(
    IN inMovementId        Integer               , -- ���� ���������
    IN inSession           TVarChar DEFAULT ''     -- ������ ������������
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId     Integer;
  DECLARE vbUnitId     Integer;
  DECLARE vbOperDateStart  TDateTime;
  DECLARE vbOperDateEnd    TDateTime;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId := inSession; 

     -- �������� ������ �� ����� ���������, 
     SELECT MovementDate_OperDateStart.ValueData   AS OperDateStart
          , MovementDate_OperDateEnd.ValueData     AS OperDateEnd
          , MovementLinkObject_Unit.ObjectId       AS UnitId
        INTO vbOperDateStart, vbOperDateEnd, vbUnitId
     FROM Movement AS Movement_MarginCategory 
 
          LEFT JOIN MovementDate AS MovementDate_OperDateStart
                                 ON MovementDate_OperDateStart.MovementId = Movement_MarginCategory.Id
                                AND MovementDate_OperDateStart.DescId = zc_MovementDate_OperDateStart()
          LEFT JOIN MovementDate AS MovementDate_OperDateEnd
                                 ON MovementDate_OperDateEnd.MovementId = Movement_MarginCategory.Id
                                AND MovementDate_OperDateEnd.DescId = zc_MovementDate_OperDateEnd()
 
          LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                       ON MovementLinkObject_Unit.MovementId = Movement_MarginCategory.Id
                                      AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
          LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = MovementLinkObject_Unit.ObjectId
                                                                     
     WHERE Movement_MarginCategory.Id =  inMovementId
       AND Movement_MarginCategory.DescId = zc_Movement_MarginCategory();

     --��������� ���� �� ���������� ���. ������ ������
     IF (vbOperDateStart < CURRENT_DATE) OR (vbOperDateEnd < CURRENT_DATE)
     THEN
         RAISE EXCEPTION '������. ������� �� ����� ���� �������� ������ ������. ������ ���������� ��������� ���������!';
     END IF;
     

     PERFORM lpInsertUpdate_objectFloat(zc_ObjectFloat_Price_PercentMarkup(), tmp.PriceId, 0)                          -- ��������� ��-�� < % ������� >
           , lpInsertUpdate_objectDate(zc_ObjectDate_Price_PercentMarkupDateChange(), tmp.PriceId, CURRENT_DATE)       -- ��������� ��-�� < ���� ��������� >
           , lpInsertUpdate_objectBoolean(zc_ObjectBoolean_Price_Top(), tmp.PriceId, FALSE)                            -- ��������� �������� <��� �������>
           , lpInsertUpdate_objectDate(zc_ObjectDate_Price_TopDateChange(), tmp.PriceId, CURRENT_DATE)                 -- ��������� ���� ��������� <��� �������>
     FROM (
           WITH
           
          --������ �������
           tmpMI_Master AS (SELECT MovementItem.*
                            FROM MovementItem 
                                 INNER JOIN MovementItemBoolean AS MIBoolean_Checked
                                                                ON MIBoolean_Checked.MovementItemId = MovementItem.Id
                                                               AND MIBoolean_Checked.DescId = zc_MIBoolean_Checked()
                                                               AND MIBoolean_Checked.ValueData = TRUE
                            WHERE MovementItem.MovementId = inMovementId
                              AND MovementItem.DescId     = zc_MI_Master()
                              AND MovementItem.isErased   = FALSE
                           )
         -- �������� ������ ������
         , tmpPrice AS (SELECT ObjectLink_Price_Unit.ObjectId         AS Id
                             , Price_Goods.ChildObjectId              AS GoodsId
                        FROM ObjectLink AS ObjectLink_Price_Unit
                             INNER JOIN ObjectLink AS Price_Goods
                                                   ON Price_Goods.ObjectId = ObjectLink_Price_Unit.ObjectId
                                                  AND Price_Goods.DescId = zc_ObjectLink_Price_Goods()
                                    
                             INNER JOIN (SELECT DISTINCT tmpMI_Master.ObjectId 
                                         FROM tmpMI_Master) AS tmpMI_Master 
                                                            ON tmpMI_Master.ObjectId = Price_Goods.ChildObjectId
                        WHERE ObjectLink_Price_Unit.DescId = zc_ObjectLink_Price_Unit()
                          AND ObjectLink_Price_Unit.ChildObjectId = vbUnitId
                        )
         -- ��������
         SELECT tmpPrice.Id                              AS PriceId
         FROM tmpMI_Master
              INNER JOIN tmpPrice ON tmpPrice.GoodsId = tmpMI_Master.ObjectId
         ) AS tmp;


     -- ����������� ��������
     PERFORM lpUnComplete_Movement (inMovementId := inMovementId
                                  , inUserId     := vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 06.12.17         *
 21.11.17         *
*/

-- ����
-- SELECT * FROM gpUnComplete_Movement_MarginCategory (inMovementId:= 149639, inSession:= zfCalc_UserAdmin())
