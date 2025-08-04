-- Function: gpGet_Scale_MI_Goods_gofro()

DROP FUNCTION IF EXISTS gpGet_Scale_MI_Goods_gofro (Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Scale_MI_Goods_gofro(
    IN inMovementId      Integer      ,
    IN inParnerId        Integer      ,
    IN inBranchCode      Integer      , --
    IN inSession         TVarChar       -- сессия пользователя
)
RETURNS TABLE (isPartner_Goods_gofro Boolean

             , GoodsId_gofro_pd      Integer
             , GoodsCode_gofro_pd    Integer
             , GoodsName_gofro_pd    TVarChar
             , Amount_gofro_pd       TFloat

             , GoodsId_gofro_box     Integer
             , GoodsCode_gofro_box   Integer
             , GoodsName_gofro_box   TVarChar
             , Amount_gofro_box      TFloat

             , GoodsId_gofro_ugol    Integer
             , GoodsCode_gofro_ugol  Integer
             , GoodsName_gofro_ugol  TVarChar
             , Amount_gofro_ugol     TFloat

             , GoodsId_gofro_1    Integer
             , GoodsCode_gofro_1  Integer
             , GoodsName_gofro_1  TVarChar
             , Amount_gofro_1     TFloat

             , GoodsId_gofro_2    Integer
             , GoodsCode_gofro_2  Integer
             , GoodsName_gofro_2  TVarChar
             , Amount_gofro_2     TFloat

             , GoodsId_gofro_3    Integer
             , GoodsCode_gofro_3  Integer
             , GoodsName_gofro_3  TVarChar
             , Amount_gofro_3     TFloat

             , GoodsId_gofro_4    Integer
             , GoodsCode_gofro_4  Integer
             , GoodsName_gofro_4  TVarChar
             , Amount_gofro_4     TFloat

             , GoodsId_gofro_5    Integer
             , GoodsCode_gofro_5  Integer
             , GoodsName_gofro_5  TVarChar
             , Amount_gofro_5     TFloat

             , GoodsId_gofro_6    Integer
             , GoodsCode_gofro_6  Integer
             , GoodsName_gofro_6  TVarChar
             , Amount_gofro_6     TFloat

             , GoodsId_gofro_7    Integer
             , GoodsCode_gofro_7  Integer
             , GoodsName_gofro_7  TVarChar
             , Amount_gofro_7     TFloat

             , GoodsId_gofro_8    Integer
             , GoodsCode_gofro_8  Integer
             , GoodsName_gofro_8  TVarChar
             , Amount_gofro_8     TFloat
              )
AS
$BODY$
   DECLARE vbUserId          Integer;
   DECLARE vbMovementId_Sale Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId:= lpGetUserBySession (inSession);


   IF EXISTS (SELECT 1 FROM ObjectBoolean AS OB WHERE OB.ObjectId = inParnerId AND OB.DescId = zc_ObjectBoolean_Partner_GoodsBox() AND OB.ValueData = TRUE)
      AND vbUserId = 5
      AND 1=1
   THEN

    vbMovementId_Sale:= (SELECT Movement.ParentId FROM Movement WHERE Movement.Id = inMovementId);

    -- Результат
    RETURN QUERY
       WITH tmpMI_all AS (SELECT MILO_Box.ObjectId AS BoxId
                               , SUM (COALESCE (MIF_BoxCount.ValueData, 0)) AS BoxCount
                          FROM MovementItem
                               LEFT JOIN MovementItemFloat AS MIF_BoxCount
                                                           ON MIF_BoxCount.MovementItemId = MovementItem.Id
                                                          AND MIF_BoxCount.DescId         = zc_MIFloat_BoxCount()
                               LEFT JOIN MovementItemLinkObject AS MILO_Box
                                                                ON MILO_Box.MovementItemId = MovementItem.Id
                                                               AND MILO_Box.DescId         = zc_MILinkObject_Box()
                          WHERE MovementItem.MovementId   = inMovementId -- vbMovementId_Sale --
                                AND MovementItem.DescId   = zc_MI_Master()
                                AND MovementItem.isErased = FALSE
                          GROUP BY MILO_Box.ObjectId
                         )
       , tmpMI_pd AS (SELECT tmpMI_all.BoxId
                           , tmpMI_all.BoxCount :: TFloat AS BoxCount
                           , Object_Box.ObjectCode AS BoxCode
                           , Object_Box.ValueData  AS BoxName
                      FROM tmpMI_all
                           LEFT JOIN Object AS Object_Box ON Object_Box.Id = tmpMI_all.BoxId
                      WHERE Object_Box.ValueData ILIKE '%поддон%'
                      ORDER BY tmpMI_all.BoxId
                      LIMIT 1
                     )
      , tmpMI_box AS (SELECT tmpMI_all.BoxId
                           , tmpMI_all.BoxCount :: TFloat AS BoxCount
                           , Object_Box.ObjectCode AS BoxCode
                           , Object_Box.ValueData  AS BoxName
                      FROM tmpMI_all
                           LEFT JOIN Object AS Object_Box ON Object_Box.Id = tmpMI_all.BoxId
                      WHERE Object_Box.ValueData ILIKE '%ящик%'
                      ORDER BY tmpMI_all.BoxId
                      LIMIT 1
                     )
    , tmpMI_ugol AS (SELECT tmpMI_all.BoxId
                           , tmpMI_all.BoxCount :: TFloat AS BoxCount
                           , Object_Box.ObjectCode AS BoxCode
                           , Object_Box.ValueData  AS BoxName
                      FROM tmpMI_all
                           LEFT JOIN Object AS Object_Box ON Object_Box.Id = tmpMI_all.BoxId
                      WHERE Object_Box.ValueData ILIKE '%уголок%'
                      ORDER BY tmpMI_all.BoxId
                      LIMIT 1
                     )
          , tmpMI AS (SELECT tmpMI_all.BoxId
                           , tmpMI_all.BoxCount :: TFloat AS BoxCount
                           , Object_Box.ObjectCode AS BoxCode
                           , Object_Box.ValueData  AS BoxName
                             -- № п/п
                           , ROW_NUMBER() OVER (ORDER BY Object_Box.ValueData ASC) AS Ord
                      FROM tmpMI_all
                           LEFT JOIN Object AS Object_Box ON Object_Box.Id = tmpMI_all.BoxId
                           LEFT JOIN tmpMI_pd   ON tmpMI_pd.BoxId   = tmpMI_all.BoxId
                           LEFT JOIN tmpMI_box  ON tmpMI_box.BoxId  = tmpMI_all.BoxId
                           LEFT JOIN tmpMI_ugol ON tmpMI_ugol.BoxId = tmpMI_all.BoxId
                      WHERE tmpMI_all.BoxId > 0
                        AND tmpMI_pd.BoxId   IS NULL
                        AND tmpMI_box.BoxId  IS NULL
                        AND tmpMI_ugol.BoxId IS NULL
                     )


       -- Результат
       SELECT TRUE :: Boolean    AS isPartner_Goods_gofro

            , tmpMI_pd.BoxId      AS GoodsId_gofro_pd
            , tmpMI_pd.BoxCode    AS GoodsCode_gofro_pd
            , tmpMI_pd.BoxName    AS GoodsName_gofro_pd
            , tmpMI_pd.BoxCount   AS Amount_gofro_pd

            , tmpMI_box.BoxId      AS GoodsId_gofro_box
            , tmpMI_box.BoxCode    AS GoodsCode_gofro_box
            , tmpMI_box.BoxName    AS GoodsName_gofro_box
            , tmpMI_box.BoxCount   AS Amount_gofro_box

            , tmpMI_ugol.BoxId      AS GoodsId_gofro_ugol
            , tmpMI_ugol.BoxCode    AS GoodsCode_gofro_ugol
            , tmpMI_ugol.BoxName    AS GoodsName_gofro_ugol
            , tmpMI_ugol.BoxCount   AS Amount_gofro_ugol

            , tmpMI_1.BoxId      AS GoodsId_gofro_1
            , tmpMI_1.BoxCode    AS GoodsCode_gofro_1
            , tmpMI_1.BoxName    AS GoodsName_gofro_1
            , tmpMI_1.BoxCount   AS Amount_gofro_1

            , tmpMI_2.BoxId      AS GoodsId_gofro_2
            , tmpMI_2.BoxCode    AS GoodsCode_gofro_2
            , tmpMI_2.BoxName    AS GoodsName_gofro_2
            , tmpMI_2.BoxCount   AS Amount_gofro_2

            , tmpMI_3.BoxId      AS GoodsId_gofro_3
            , tmpMI_3.BoxCode    AS GoodsCode_gofro_3
            , tmpMI_3.BoxName    AS GoodsName_gofro_3
            , tmpMI_3.BoxCount   AS Amount_gofro_3

            , tmpMI_4.BoxId      AS GoodsId_gofro_4
            , tmpMI_4.BoxCode    AS GoodsCode_gofro_4
            , tmpMI_4.BoxName    AS GoodsName_gofro_4
            , tmpMI_4.BoxCount   AS Amount_gofro_4

            , tmpMI_5.BoxId      AS GoodsId_gofro_5
            , tmpMI_5.BoxCode    AS GoodsCode_gofro_5
            , tmpMI_5.BoxName    AS GoodsName_gofro_5
            , tmpMI_5.BoxCount   AS Amount_gofro_5

            , tmpMI_6.BoxId      AS GoodsId_gofro_6
            , tmpMI_6.BoxCode    AS GoodsCode_gofro_6
            , tmpMI_6.BoxName    AS GoodsName_gofro_6
            , tmpMI_6.BoxCount   AS Amount_gofro_6

            , tmpMI_7.BoxId      AS GoodsId_gofro_7
            , tmpMI_7.BoxCode    AS GoodsCode_gofro_7
            , tmpMI_7.BoxName    AS GoodsName_gofro_7
            , tmpMI_7.BoxCount   AS Amount_gofro_7

            , tmpMI_8.BoxId      AS GoodsId_gofro_8
            , tmpMI_8.BoxCode    AS GoodsCode_gofro_8
            , tmpMI_8.BoxName    AS GoodsName_gofro_8
            , tmpMI_8.BoxCount   AS Amount_gofro_8

       FROM (SELECT 1 AS x) AS tmp
            LEFT JOIN tmpMI_pd   ON tmpMI_pd.BoxId   > 0
            LEFT JOIN tmpMI_box  ON tmpMI_box.BoxId  > 0
            LEFT JOIN tmpMI_ugol ON tmpMI_ugol.BoxId > 0
            --
            LEFT JOIN tmpMI AS tmpMI_1 ON tmpMI_1.Ord = 1
            LEFT JOIN tmpMI AS tmpMI_2 ON tmpMI_2.Ord = 2
            LEFT JOIN tmpMI AS tmpMI_3 ON tmpMI_3.Ord = 3
            LEFT JOIN tmpMI AS tmpMI_4 ON tmpMI_4.Ord = 4
            LEFT JOIN tmpMI AS tmpMI_5 ON tmpMI_5.Ord = 5
            LEFT JOIN tmpMI AS tmpMI_6 ON tmpMI_6.Ord = 6
            LEFT JOIN tmpMI AS tmpMI_7 ON tmpMI_7.Ord = 7
            LEFT JOIN tmpMI AS tmpMI_8 ON tmpMI_8.Ord = 8
      ;

    ELSE


    RETURN QUERY
       -- Результат
       SELECT FALSE :: Boolean    AS isPartner_Goods_gofro

            , 0  :: Integer
            , 0  :: Integer
            , '' :: TVarChar
            , 0  :: TFloat

            , 0  :: Integer
            , 0  :: Integer
            , '' :: TVarChar
            , 0  :: TFloat

            , 0  :: Integer
            , 0  :: Integer
            , '' :: TVarChar
            , 0  :: TFloat

            , 0  :: Integer
            , 0  :: Integer
            , '' :: TVarChar
            , 0  :: TFloat

            , 0  :: Integer
            , 0  :: Integer
            , '' :: TVarChar
            , 0  :: TFloat

            , 0  :: Integer
            , 0  :: Integer
            , '' :: TVarChar
            , 0  :: TFloat

            , 0  :: Integer
            , 0  :: Integer
            , '' :: TVarChar
            , 0  :: TFloat

            , 0  :: Integer
            , 0  :: Integer
            , '' :: TVarChar
            , 0  :: TFloat

            , 0  :: Integer
            , 0  :: Integer
            , '' :: TVarChar
            , 0  :: TFloat

            , 0  :: Integer
            , 0  :: Integer
            , '' :: TVarChar
            , 0  :: TFloat

            , 0  :: Integer
            , 0  :: Integer
            , '' :: TVarChar
            , 0  :: TFloat
             ;

    END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 01.07.25                                        *
*/

-- тест
-- SELECT * FROM gpGet_Scale_MI_Goods_gofro (31880127, 10091394, 1, zfCalc_UserAdmin())
