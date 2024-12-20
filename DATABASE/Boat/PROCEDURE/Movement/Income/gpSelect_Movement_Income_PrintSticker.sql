-- Function: gpSelect_Movement_Income_PrintSticker (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Movement_Income_PrintSticker (Integer, TVarChar);
--DROP FUNCTION IF EXISTS gpSelect_Movement_Income_PrintSticker (Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Movement_Income_PrintSticker (Integer, Integer, BooLean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_Income_PrintSticker(
    IN inMovementId        Integer   ,   -- ���� ���������
    IN inMovementItemId    Integer   ,   -- ����    
    IN inisPrice           BooLean   ,   -- �������� ���� ��� ��� �� ������ - zc_PriceList_Basis()
    IN inSession           TVarChar      -- ������ ������������
)
RETURNS SETOF refcursor
AS
$BODY$
    DECLARE vbUserId Integer;
    DECLARE Cursor1 refcursor;
    DECLARE vbDescId Integer;
    DECLARE vbStatusId Integer;
    DECLARE vbOperDate TDateTime;
    DECLARE vbFromCode Integer;
    DECLARE vbFromName TVarChar;

BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
     vbUserId:= lpGetUserBySession (inSession);

     -- ��������� �� ���������
     SELECT Movement.DescId, Movement.StatusId, Movement.OperDate
          , Object_From.ObjectCode                     AS FromCode
          , Object_From.ValueData                      AS FromName
   INTO vbDescId, vbStatusId, vbOperDate
      , vbFromCode, vbFromName
     FROM Movement
         LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                      ON MovementLinkObject_From.MovementId = Movement.Id
                                     AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
         LEFT JOIN Object AS Object_From   ON Object_From.Id   = MovementLinkObject_From.ObjectId
     WHERE Movement.Id = inMovementId;

     -- �������� - � ����� �������� ����� ��������
    IF COALESCE (vbStatusId, 0) <> zc_Enum_Status_Complete() AND 1=0
    THEN
        IF vbStatusId = zc_Enum_Status_Erased()
        THEN
            RAISE EXCEPTION '������.�������� <%> � <%> �� <%> ������.', (SELECT ItemName FROM MovementDesc WHERE Id = vbDescId), (SELECT InvNumber FROM Movement WHERE Id = inMovementId), (SELECT DATE (OperDate) FROM Movement WHERE Id = inMovementId);
        END IF;
        IF vbStatusId = zc_Enum_Status_UnComplete()
        THEN
            RAISE EXCEPTION '������.�������� <%> � <%> �� <%> �� ��������.', (SELECT ItemName FROM MovementDesc WHERE Id = vbDescId), (SELECT InvNumber FROM Movement WHERE Id = inMovementId), (SELECT DATE (OperDate) FROM Movement WHERE Id = inMovementId);
        END IF;
    END IF;

     -- ���������
     OPEN Cursor1 FOR
       WITH tmpMI AS (SELECT MovementItem.Id
                           , MovementItem.ObjectId   AS GoodsId
                      FROM MovementItem
                      WHERE MovementItem.MovementId = inMovementId
                        AND MovementItem.DescId     IN (zc_MI_Master(), 5)
                        AND MovementItem.isErased   = FALSE
                        AND MovementItem.Amount     <> 0
                        AND (MovementItem.Id = inMovementItemId OR COALESCE (inMovementItemId, 0) = 0)
                     )  
           , tmpPriceBasis AS (SELECT tmp.GoodsId
                                    , tmp.ValuePrice
                               FROM tmpMI
                                    INNER JOIN (SELECT tmp.GoodsId, tmp.ValuePrice
                                                FROM lfSelect_ObjectHistory_PriceListItem (inPriceListId:= zc_PriceList_Basis()
                                                                                         , inOperDate   := vbOperDate) AS tmp
                                                ) AS tmp ON tmp.GoodsId = tmpMI.GoodsId
                               WHERE inisPrice = TRUE
                              )
       -- ���������
       SELECT
             tmpMI.Id
           , Object_Goods.Id                AS GoodsId
           , Object_Goods.ObjectCode        AS GoodsCode
           , Object_Goods.ValueData         AS GoodsName
           , zfFormat_BarCode (zc_BarCodePref_Object(), Object_Goods.ObjectCode) AS IdBarCode
           , ObjectString_Article.ValueData AS Article
           , MIString_PartNumber.ValueData  AS PartNumber
           , vbFromCode AS FromCode
           , vbFromName AS FromName 
           , CASE WHEN inisPrice = TRUE THEN COALESCE (MIFloat_OperPriceList.ValueData, tmpPriceBasis.ValuePrice, 0) ELSE NULL END :: TFloat  AS OperPriceList 
       FROM tmpMI
            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpMI.GoodsId

            LEFT JOIN ObjectString AS ObjectString_Article
                                   ON ObjectString_Article.ObjectId = tmpMI.GoodsId
                                  AND ObjectString_Article.DescId = zc_ObjectString_Article()
            LEFT JOIN MovementItemString AS MIString_PartNumber
                                         ON MIString_PartNumber.MovementItemId = tmpMI.Id
                                        AND MIString_PartNumber.DescId = zc_MIString_PartNumber()  
            LEFT JOIN MovementItemFloat AS MIFloat_OperPriceList
                                        ON MIFloat_OperPriceList.MovementItemId = tmpMI.Id
                                       AND MIFloat_OperPriceList.DescId = zc_MIFloat_OperPriceList()
            LEFT JOIN tmpPriceBasis ON tmpPriceBasis.GoodsId = tmpMI.GoodsId 
       ORDER BY Object_Goods.ValueData
       ;

    RETURN NEXT Cursor1;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
28.09.21          *
*/

-- ����
-- SELECT * FROM gpSelect_Movement_Income_PrintSticker (inMovementId:= 432692, inMovementItemId:= 0, inisPrice:=False inSession:= '5');


select * from gpSelect_Movement_Income_PrintSticker(inMovementId := 716 , inMovementItemId := 0 , inIsPrice := 'False' ,  inSession := '5');
