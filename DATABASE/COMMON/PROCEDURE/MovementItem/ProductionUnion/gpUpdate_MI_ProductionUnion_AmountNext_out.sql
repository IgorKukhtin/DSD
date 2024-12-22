 -- Function: gpUpdate_MI_ProductionUnion_AmountNext_out()

DROP FUNCTION IF EXISTS gpUpdate_MI_ProductionUnion_AmountNext_out (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MI_ProductionUnion_AmountNext_out(
    IN inMovementId       Integer   , -- ���� ������� <>
    IN inSession          TVarChar    -- ������ ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbFromId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Update_MI_ProductionUnion_AmountNext_out());

   -- ��������
   IF COALESCE (inMovementId, 0) = 0
   THEN
       RAISE EXCEPTION '������.�������� �� ��������.';
   END IF;


   vbFromId := (SELECT MLO_From.ObjectId
                FROM MovementLinkObject AS MLO_From
                WHERE MLO_From.MovementId = inMovementId
                  AND MLO_From.DescId = zc_MovementLinkObject_From()
               );


   -- ��������� �������� <����������� �/� (������/������), ��>
   PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountNext_out(), tmp.MovementItemId, 1 * COALESCE (tmp.AmountNext, 0) ::TFloat)
   FROM (WITH -- ������� �/� ��
              tmpMI_WorkProgress_in
                       AS (SELECT MIContainer.MovementItemId              AS MovementItemId
                                , MIContainer.ContainerId                 AS ContainerId
                           FROM MovementItemContainer AS MIContainer
                                -- ��� �����������
                                LEFT JOIN MovementBoolean AS MovementBoolean_Peresort
                                                          ON MovementBoolean_Peresort.MovementId = MIContainer.MovementId
                                                         AND MovementBoolean_Peresort.DescId = zc_MovementBoolean_Peresort()
                                                         AND MovementBoolean_Peresort.ValueData = TRUE

                           WHERE MIContainer.MovementId = inMovementId
                             AND MIContainer.DescId = zc_MIContainer_Count()
                             AND MIContainer.MovementDescId = zc_Movement_ProductionUnion()
                             AND MIContainer.IsActive = TRUE
                             -- !!!������ �����������!!!
                             AND MovementBoolean_Peresort.MovementId IS NULL
                             --
                             AND MIContainer.Amount <> 0
                             -- ����������� ��� ��� �/� ��
                             AND MIContainer.ObjectIntId_Analyzer IN (zc_GoodsKind_WorkProgress(), zc_GoodsKind_Basis())
                           )
             -- ������� �/� ��
            , tmpMI_WorkProgress_all AS
                          (SELECT tmpMI_WorkProgress_in.MovementItemId
                                  -- ���� ������ ����������� �������
                                , SUM (MIContainer.Amount)              AS AmountNext_out
                                  -- ���� �������� ����������� �������
                                , SUM (CASE WHEN MLO_From.ObjectId = MLO_To.ObjectId
                                                 THEN -1 * MIContainer.Amount
                                            ELSE 0
                                       END) AS AmountNext_in
                                  -- ������ ���� ���� �������� ����������� �������
                                , CASE WHEN MLO_From.ObjectId = MLO_To.ObjectId
                                            THEN MIContainer_parent.ContainerId
                                       ELSE 0
                                  END AS ContainerId_in
                           FROM tmpMI_WorkProgress_in
                                INNER JOIN MovementItemContainer AS MIContainer
                                                                 ON MIContainer.ContainerId     = tmpMI_WorkProgress_in.ContainerId
                                                                AND MIContainer.MovementDescId = zc_Movement_ProductionUnion()
                                                                AND MIContainer.IsActive       = FALSE

                                -- ������ �����������
                                INNER JOIN MovementBoolean AS MovementBoolean_Peresort
                                                           ON MovementBoolean_Peresort.MovementId = MIContainer.MovementId
                                                          AND MovementBoolean_Peresort.DescId     = zc_MovementBoolean_Peresort()
                                                          AND MovementBoolean_Peresort.ValueData  = TRUE

                                LEFT JOIN MovementLinkObject AS MLO_From ON MLO_From.MovementId = MIContainer.MovementId
                                                                        AND MLO_From.DescId     = zc_MovementLinkObject_From()
                                LEFT JOIN MovementLinkObject AS MLO_To ON MLO_To.MovementId = MIContainer.MovementId
                                                                      AND MLO_To.DescId     = zc_MovementLinkObject_To()

                                -- ����� �������
                                LEFT JOIN MovementItemContainer AS MIContainer_parent ON MIContainer_parent.Id = MIContainer.Id
                                                                                     --  ����� ������ ����� ������
                                                                                     AND MLO_From.ObjectId = MLO_To.ObjectId

                          GROUP BY tmpMI_WorkProgress_in.MovementItemId
                                , CASE WHEN MLO_From.ObjectId = MLO_To.ObjectId
                                            THEN MIContainer_parent.ContainerId
                                       ELSE 0
                                  END
                         )

         -- ���� ������ ����������� �������
         SELECT tmpMI_WorkProgress_all.MovementItemId  AS MovementItemId
              , tmpMI_WorkProgress_all.AmountNext_out  AS AmountNext
         FROM tmpMI_WorkProgress_all

        UNION ALL
         -- ���� �������� ����������� �������
         SELECT tmpMI_WorkProgress_in.MovementItemId   AS MovementItemId -- !!!� ��� ������!!!
              , tmpMI_WorkProgress_all.AmountNext_in   AS AmountNext
         FROM tmpMI_WorkProgress_all
              -- ����� ������
              INNER JOIN tmpMI_WorkProgress_in ON tmpMI_WorkProgress_in.ContainerId = tmpMI_WorkProgress_all.ContainerId_in

        ) AS tmp;


     IF vbUserId = 9457
     THEN
         RAISE EXCEPTION 'Test. Ok!';
     END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 13.08.24         *
*/

/*
select * 
-- , gpUpdate_MI_ProductionUnion_AmountNext_out (inMovementId:= Movement.Id, inSession:= '5')
from Movement
                                LEFT JOIN MovementLinkObject AS MLO_From ON MLO_From.MovementId = Movement.Id
                                                                        AND MLO_From.DescId     = zc_MovementLinkObject_From()
                                LEFT JOIN MovementLinkObject AS MLO_To ON MLO_To.MovementId = Movement.Id
                                                                      AND MLO_To.DescId     = zc_MovementLinkObject_To()

                                -- ��� �����������
                                LEFT JOIN MovementBoolean AS MovementBoolean_Peresort
                                                          ON MovementBoolean_Peresort.MovementId = Movement.Id
                                                         AND MovementBoolean_Peresort.DescId = zc_MovementBoolean_Peresort()
                                                         AND MovementBoolean_Peresort.ValueData = TRUE
where OperDate between '01.06.2024' and '30.06.2024'
  and Movement.DescId = zc_Movement_ProductionUnion()
  and MLO_From.ObjectId = MLO_To.ObjectId
                             -- !!!������ �����������!!!
                             AND MovementBoolean_Peresort.MovementId IS NULL
*/
-- ����
-- SELECT * FROM gpUpdate_MI_ProductionUnion_AmountNext_out (inMovementId:= 28608090, inSession:= '9457');
