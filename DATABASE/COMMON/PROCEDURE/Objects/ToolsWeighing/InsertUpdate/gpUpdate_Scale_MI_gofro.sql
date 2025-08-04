-- Function: gpUpdate_Scale_MI_gofro() - �����-�����+������+����+�����-������

DROP FUNCTION IF EXISTS gpUpdate_Scale_MI_gofro (Integer, Integer, TFloat, Integer, TFloat, Integer, TFloat, Integer, TFloat, Integer, TFloat, Integer, TFloat, Integer, TFloat, Integer, TFloat, Integer, TFloat, Integer, TFloat, Integer, TFloat, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Scale_MI_gofro(
    IN inMovementId         Integer  ,
    -- ������
    IN inGoodsId_gofro_pd   Integer , --
    IN inAmount_gofro_pd    TFloat  , --
    -- ����
    IN inGoodsId_gofro_box  Integer , --
    IN inAmount_gofro_box   TFloat  , --
    -- �����-������
    IN inGoodsId_gofro_ugol Integer , --
    IN inAmount_gofro_ugol  TFloat  , --
    -- �����-����
    IN inGoodsId_gofro_1    Integer , --
    IN inAmount_gofro_1     TFloat  , --
    IN inGoodsId_gofro_2    Integer , --
    IN inAmount_gofro_2     TFloat  , --
    IN inGoodsId_gofro_3    Integer , --
    IN inAmount_gofro_3     TFloat  , --
    IN inGoodsId_gofro_4    Integer , --
    IN inAmount_gofro_4     TFloat  , --
    IN inGoodsId_gofro_5    Integer , --
    IN inAmount_gofro_5     TFloat  , --
    IN inGoodsId_gofro_6    Integer , --
    IN inAmount_gofro_6     TFloat  , --
    IN inGoodsId_gofro_7    Integer , --
    IN inAmount_gofro_7     TFloat  , --
    IN inGoodsId_gofro_8    Integer , --
    IN inAmount_gofro_8     TFloat  , --
    IN inBranchCode         Integer , --
    IN inSession            TVarChar  -- ������ ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId               Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpGetUserBySession (inSession);


     IF COALESCE (inMovementId, 0) = 0
     THEN
         RAISE EXCEPTION '������.�� ��������� �������� ��� ���������� ���������.';
     END IF;
   
     IF EXISTS (SELECT 1 FROM Movement WHERE Movement.Id = inMovementId AND Movement.StatusId = zc_Enum_Status_Complete())
     THEN
         -- !!! �������������!!!
         PERFORM lpUnComplete_Movement (inMovementId:= inMovementId, inUserId:= vbUserId);
     END IF;
     

     -- ��������� ��������
     PERFORM lpInsert_MovementItemProtocol (tmpMI_res.MovementItemId, vbUserId, tmpMI_res.isInsert)
     FROM (SELECT tmpMI_res.MovementItemId
                , tmpMI_res.isInsert
                  -- ��������� ��������
                , lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Box(), tmpMI_res.MovementItemId, tmpMI_res.BoxId) AS x1
                  -- ��������� ��������
                , lpInsertUpdate_MovementItemFloat (zc_MIFloat_BoxCount(), tmpMI_res.MovementItemId, tmpMI_res.BoxCount)   AS x2

           FROM (WITH tmpMI AS (SELECT MovementItem.Id                          AS MovementItemId
                                     , MovementItem.ObjectId                    AS GoodsId
                                     , MovementItem.Amount                      AS Amount
                                     , COALESCE (MILinkObject_Box.ObjectId, 0)  AS BoxId
                                     , COALESCE (MIFloat_BoxCount.ValueData, 0) AS BoxCount
                                FROM MovementItem
                                     LEFT JOIN MovementItemLinkObject AS MILinkObject_Box
                                                                      ON MILinkObject_Box.MovementItemId = MovementItem.Id
                                                                     AND MILinkObject_Box.DescId         = zc_MILinkObject_Box()
                                     LEFT JOIN MovementItemFloat AS MIFloat_BoxCount
                                                                 ON MIFloat_BoxCount.MovementItemId = MovementItem.Id
                                                                AND MIFloat_BoxCount.DescId         = zc_MIFloat_BoxCount()
                                WHERE MovementItem.MovementId = inMovementId
                                  AND MovementItem.DescId     = zc_MI_Master()
                                  AND MovementItem.isErased   = FALSE
                               )
                 , tmpBox_new AS (-- ������
                                  SELECT inGoodsId_gofro_pd AS BoxId, inAmount_gofro_pd AS BoxCount WHERE inAmount_gofro_pd > 0
                                  -- ����
                            UNION SELECT inGoodsId_gofro_box, inAmount_gofro_box WHERE inAmount_gofro_box > 0
                                  -- �����-������
                            UNION SELECT inGoodsId_gofro_ugol, inAmount_gofro_ugol WHERE inAmount_gofro_ugol > 0
                                  -- �����-����
                            UNION SELECT inGoodsId_gofro_1, inAmount_gofro_1 WHERE inAmount_gofro_1 > 0
                            UNION SELECT inGoodsId_gofro_2, inAmount_gofro_2 WHERE inAmount_gofro_2 > 0
                            UNION SELECT inGoodsId_gofro_3, inAmount_gofro_3 WHERE inAmount_gofro_3 > 0
                            UNION SELECT inGoodsId_gofro_4, inAmount_gofro_4 WHERE inAmount_gofro_4 > 0
                            UNION SELECT inGoodsId_gofro_5, inAmount_gofro_5 WHERE inAmount_gofro_5 > 0
                            UNION SELECT inGoodsId_gofro_6, inAmount_gofro_6 WHERE inAmount_gofro_6 > 0
                            UNION SELECT inGoodsId_gofro_7, inAmount_gofro_7 WHERE inAmount_gofro_7 > 0
                            UNION SELECT inGoodsId_gofro_8, inAmount_gofro_8 WHERE inAmount_gofro_8 > 0
                                 )
                , tmpMI_find AS (-- ����� � ��������� ��-��
                                 SELECT tmpMI.MovementItemId
                                        -- ����
                                      , tmpMI.BoxId
                                      , tmpMI.BoxCount AS BoxCount_old
                                        -- �������������� �����
                                      , CAST (COALESCE (tmpBox_sum_new.BoxCount, 0) * tmpMI.BoxCount / tmpMI_sum.BoxCount AS Integer) AS BoxCount
                                        -- ��������� ����� ������� ����� �������������
                                      , ROW_NUMBER() OVER (PARTITION BY tmpMI.BoxId ORDER BY tmpMI.BoxCount DESC, tmpMI.MovementItemId ASC) AS Ord
                                 FROM tmpMI
                                      -- ����� �� ������ - ���� � BoxId
                                      INNER JOIN (SELECT SUM (tmpMI.BoxCount) AS BoxCount, tmpMI.BoxId FROM tmpMI WHERE tmpMI.BoxId > 0 GROUP BY tmpMI.BoxId
                                                 ) AS tmpMI_sum
                                                   ON tmpMI_sum.BoxId    = tmpMI.BoxId
                                                  AND tmpMI_sum.BoxCount > 0
                                      -- ����� ������� ���� ���������
                                      LEFT JOIN (SELECT SUM (tmpBox_new.BoxCount) AS BoxCount, tmpBox_new.BoxId FROM tmpBox_new GROUP BY tmpBox_new.BoxId
                                                ) AS tmpBox_sum_new
                                                  ON tmpBox_sum_new.BoxId = tmpMI.BoxId
                                UNION
                                 -- ����� � GoodsId
                                 SELECT tmpMI.MovementItemId
                                        -- ����
                                      , tmpMI.GoodsId AS BoxId
                                      , tmpMI.Amount  AS BoxCount_old
                                        -- �������������� �����
                                      , CAST (tmpBox_sum_new.BoxCount * tmpMI.Amount / tmpMI_sum.Amount AS Integer) AS BoxCount
                                        -- ��������� ����� ������� ����� �������������
                                      , ROW_NUMBER() OVER (PARTITION BY tmpMI.GoodsId ORDER BY tmpMI.Amount DESC, tmpMI.MovementItemId) AS Ord
                                 FROM tmpMI
                                      -- ���� ��� � ������
                                      LEFT JOIN (SELECT DISTINCT tmpMI.BoxId FROM tmpMI WHERE tmpMI.BoxId > 0) AS tmpMI_find ON tmpMI_find.BoxId = tmpMI.GoodsId
       
                                      -- ����� �� ������ - ���� � GoodsId
                                      INNER JOIN (SELECT SUM (tmpMI.Amount) AS Amount, tmpMI.GoodsId AS BoxId FROM tmpMI WHERE tmpMI.GoodsId > 0 GROUP BY tmpMI.GoodsId
                                                 ) AS tmpMI_sum
                                                   ON tmpMI_sum.BoxId    = tmpMI.GoodsId
                                                  AND tmpMI_sum.Amount > 0
                                                  -- ���� ��� � ������
                                                  AND tmpMI_find.BoxId IS NULL
                                      -- ����� ������� ���� ���������
                                      INNER JOIN (SELECT SUM (tmpBox_new.BoxCount) AS BoxCount, tmpBox_new.BoxId FROM tmpBox_new GROUP BY tmpBox_new.BoxId
                                                 ) AS tmpBox_sum_new
                                                   ON tmpBox_sum_new.BoxId = tmpMI.GoodsId
                                )
       
                 , tmpMI_new AS (SELECT tmpMI_find.MovementItemId
                                        -- ����
                                      , tmpMI_find.BoxId
                                      , tmpMI_find.BoxCount_old
                                        -- �������������� �����
                                      , tmpMI_find.BoxCount
                                        -- ���� ������������ �� ������� ����� �������������
                                      + CASE WHEN tmpMI_find.Ord = 1 THEN COALESCE (tmpBox_sum_new.BoxCount, 0) - tmpMI_find_sum.BoxCount ELSE 0 END
                                        AS BoxCount
       
                                 FROM tmpMI_find
                                      -- ����� ����� ����� �������������
                                      INNER JOIN (SELECT SUM (tmpMI_find.BoxCount) AS BoxCount, tmpMI_find.BoxId FROM tmpMI_find GROUP BY tmpMI_find.BoxId
                                                 ) AS tmpMI_find_sum
                                                   ON tmpMI_find_sum.BoxId = tmpMI_find.BoxId
                                      -- ����� ������� ���� ���� ������������
                                      LEFT JOIN (SELECT SUM (tmpBox_new.BoxCount) AS BoxCount, tmpBox_new.BoxId FROM tmpBox_new GROUP BY tmpBox_new.BoxId
                                                 ) AS tmpBox_sum_new
                                                   ON tmpBox_sum_new.BoxId = tmpMI_find.BoxId
       
                                UNION ALL
                                 -- �������� ����� MovementItemId
                                 SELECT 0 AS MovementItemId
                                        -- ����
                                      , tmpBox_new.BoxId
                                      , 0 AS BoxCount_old
                                        -- �����
                                      , tmpBox_new.BoxCount
                                 FROM tmpBox_new
                                      -- ����� �������������
                                      LEFT JOIN tmpMI_find ON tmpMI_find.BoxId = tmpBox_new.BoxId
                                 -- ���� �� �����
                                 WHERE tmpMI_find.BoxId IS NULL
                                )
                 -- ���������
                 SELECT CASE WHEN tmpMI_new.MovementItemId = 0
                                  THEN TRUE
                             ELSE FALSE
                        END AS isInsert
                        --
                      , CASE WHEN tmpMI_new.MovementItemId = 0
                                  THEN lpInsertUpdate_MovementItem (ioId           := 0
                                                                  , inDescId       := zc_MI_Master()
                                                                  , inObjectId     := tmpMI_new.BoxId
                                                                  , inMovementId   := inMovementId
                                                                  , inAmount       := 0
                                                                  , inParentId     := NULL
                                                                  , inUserId       := 0
                                                                   )
                             ELSE tmpMI_new.MovementItemId
                        END AS MovementItemId
                        -- ����
                      , tmpMI_new.BoxId
                      , tmpMI_new.BoxCount_old
                      , tmpMI_new.BoxCount
      
                 FROM tmpMI_new
                 WHERE tmpMI_new.BoxCount_old <> tmpMI_new.BoxCount
                ) AS tmpMI_res
          ) AS tmpMI_res
         ;
         

     -- ��������� ��������
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Gofro(), inMovementId, TRUE);
     

     IF 1=1 -- EXISTS (SELECT 1 FROM Movement WHERE Movement.Id = inMovementId AND Movement.StatusId = zc_Enum_Status_UnComplete())
     THEN
         -- !!! ����������!!!
         PERFORM gpComplete_Movement_Sale (inMovementId     := inMovementId
                                         , inIsLastComplete := FALSE
                                         , inIsRecalcPrice  := FALSE
                                         , inSession        := inSession
                                          );
     END IF;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 20.07.25                                        *
*/

-- ����
-- SELECT * FROM gpUpdate_Scale_MI_gofro(inMovementId := 31880127 , inGoodsId_gofro_pd := 5798114 , inAmount_gofro_pd := 1 , inGoodsId_gofro_box := 0 , inAmount_gofro_box := 0 , inGoodsId_gofro_ugol := 0 , inAmount_gofro_ugol := 0 , inGoodsId_gofro_1 := 8481927 , inAmount_gofro_1 := 2 , inGoodsId_gofro_2 := 8481928 , inAmount_gofro_2 := 3 , inGoodsId_gofro_3 := 0 , inAmount_gofro_3 := 0 , inGoodsId_gofro_4 := 0 , inAmount_gofro_4 := 0 , inGoodsId_gofro_5 := 0 , inAmount_gofro_5 := 0 , inGoodsId_gofro_6 := 0 , inAmount_gofro_6 := 0 , inGoodsId_gofro_7 := 0 , inAmount_gofro_7 := 0 , inGoodsId_gofro_8 := 0 , inAmount_gofro_8 := 0 , inBranchCode := 1 ,  inSession := zfCalc_UserAdmin());
