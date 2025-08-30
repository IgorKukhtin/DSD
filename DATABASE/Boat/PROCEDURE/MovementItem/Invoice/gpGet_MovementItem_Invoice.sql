-- Function: gpGet_Movement_Income()

DROP FUNCTION IF EXISTS gpGet_MovementItem_Invoice (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_MovementItem_Invoice(
    IN inId             Integer  , -- ���� 
    IN inSession        TVarChar   -- ������ ������������
)
RETURNS TABLE (Id Integer
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar 
             , Article        TVarChar
             , PartnerId Integer, PartnerName TVarChar
             , Amount         TFloat 
             , AmountRemains  TFloat
             , OperPrice      TFloat
             , SummMVAT       TFloat
             , SummPVAT       TFloat     
             , Summ�_VAT      TFloat
             , Comment        TVarChar
             , t1 integer, t2 integer, t3 integer,t4 Integer
              )
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpGetUserBySession (inSession);

   IF COALESCE (inId, 0) = 0
   THEN
   RETURN QUERY
       SELECT
             CAST (0 AS Integer)    AS Id
           , CAST (0 AS Integer)    AS GoodsId
           , CAST (0 AS Integer)    AS GoodsCode
           , CAST ('' AS TVarChar)  AS GoodsName
           , CAST ('' AS TVarChar)  AS Article 
           , CAST (0 AS Integer)    AS PartnerId
           , CAST ('' AS TVarChar)  AS PartnerName
           , CAST (1 AS TFloat)     AS Amount
           , CAST (0 AS TFloat)     AS AmountRemains
           , CAST (0 AS TFloat)     AS OperPrice  
           , CAST (0 AS TFloat)     AS SummMVAT
           , CAST (0 AS TFloat)     AS SummPVAT
           , CAST (0 AS TFloat)     AS Summ�_VAT
           , CAST ('' AS TVarChar)  AS Comment
           , CAST (0 AS Integer)    AS t1 
           , CAST (0 AS Integer)    AS t2
           , CAST (0 AS Integer)    AS t3
           , CAST (0 AS Integer)    AS t3
           ;
   ELSE
         RETURN QUERY 
         WITH 
         tmpMI AS (SELECT MovementItem.* 
                   FROM MovementItem
                   WHERE MovementItem.Id = inId
                     AND MovementItem.DescId = zc_MI_Master()
                   )

         --������� �������
       , tmpRemains AS (SELECT Container.ObjectId            AS GoodsId
                             , Sum(Container.Amount)::TFloat AS Remains
                         FROM Container
                         WHERE Container.WhereObjectId = 35139 -- ����� ��������
                           AND Container.DescId        = zc_Container_Count()
                           AND Container.ObjectId IN (SELECT DISTINCT tmpMI.ObjectId FROM tmpMI)
                           AND Container.Amount <> 0
                         GROUP BY Container.ObjectId
                                --, Container.WhereObjectId
                         HAVING Sum(Container.Amount) <> 0
                        )
           -- ���������
           SELECT
                 MovementItem.Id                AS Id
               , MovementItem.ObjectId          AS GoodsId
               , Object_Goods.ObjectCode        AS GoodsCode
               , Object_Goods.ValueData         AS GoodsName 
               , ObjectString_Article.ValueData AS Article 
               , Object_Partner.Id              AS PartnerId
               , Object_Partner.ValueData       AS PartnerName
               , MovementItem.Amount                       ::TFloat AS Amount

               --������� �� ��. ������
               , tmpRemains.Remains                        ::TFloat AS AmountRemains

               , COALESCE (MIFloat_OperPrice.ValueData, 0) ::TFloat AS OperPrice 
               , COALESCE (MIFloat_SummMVAT.ValueData,0)   ::TFloat AS SummMVAT   --����� ��� ���
               , COALESCE (MIFloat_SummPVAT.ValueData,0)   ::TFloat AS SummPVAT   -- ����� � ���
               --����� ���
               , ( COALESCE (MIFloat_SummPVAT.ValueData, 0) -  COALESCE (MIFloat_SummMVAT.ValueData,0) ) ::TFloat AS Summ�_VAT 

               , COALESCE (MIString_Comment.ValueData, '') ::TVarChar AS Comment 

               --  ��� �������� ��������� ������� �������� � ���������
               , lpInsertUpdate_MovementItemFloat (zc_MIFloat_OperPrice_calc(), MovementItem.Id, COALESCE (MIFloat_OperPrice.ValueData, 0)) ::integer 
               , lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummMVAT_calc(), MovementItem.Id, COALESCE (MIFloat_SummMVAT.ValueData, 0))   ::integer
               , lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummPVAT_calc(), MovementItem.Id, COALESCE (MIFloat_SummPVAT.ValueData, 0))   ::integer
               , lpInsertUpdate_MovementItemFloat (zc_MIFloat_Amount_calc(), MovementItem.Id, MovementItem.Amount)                          ::integer

           FROM tmpMI AS MovementItem
                LEFT JOIN MovementItemFloat AS MIFloat_OperPrice
                                            ON MIFloat_OperPrice.MovementItemId = MovementItem.Id
                                           AND MIFloat_OperPrice.DescId = zc_MIFloat_OperPrice()

                LEFT JOIN MovementItemFloat AS MIFloat_SummMVAT
                                            ON MIFloat_SummMVAT.MovementItemId = MovementItem.Id
                                           AND MIFloat_SummMVAT.DescId= zc_MIFloat_SummMVAT()  --����� ��� ���
                LEFT JOIN MovementItemFloat AS MIFloat_SummPVAT
                                            ON MIFloat_SummPVAT.MovementItemId = MovementItem.Id
                                           AND MIFloat_SummPVAT.DescId = zc_MIFloat_SummPVAT() -- ����� � ���

                LEFT JOIN MovementItemString AS MIString_Comment
                                             ON MIString_Comment.MovementItemId = MovementItem.Id
                                            AND MIString_Comment.DescId = zc_MIString_Comment()

                LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId

                LEFT JOIN ObjectString AS ObjectString_Article
                                       ON ObjectString_Article.ObjectId = MovementItem.ObjectId
                                      AND ObjectString_Article.DescId   = zc_ObjectString_Article()

                LEFT JOIN ObjectLink AS ObjectLink_Goods_Partner
                                     ON ObjectLink_Goods_Partner.ObjectId = Object_Goods.Id
                                    AND ObjectLink_Goods_Partner.DescId = zc_ObjectLink_Goods_Partner()
                LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = ObjectLink_Goods_Partner.ChildObjectId

                LEFT JOIN tmpRemains ON tmpRemains.GoodsId = Object_Goods.Id
           ;
   END IF;
   
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����111
               ������� �.�.   ������ �.�.   ���������� �.�.
 07.12.23         *
*/

-- ����
-- SELECT * FROM gpGet_MovementItem_Invoice (inId:= 0, inSession:= '5'::TVarChar);
