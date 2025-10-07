-- Function: gpSelect_Movement_Invoice_Item()

DROP FUNCTION IF EXISTS gpSelect_Movement_Invoice_Item (TDateTime, TDateTime, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_Invoice_Item(
    IN inStartDate     TDateTime , --
    IN inEndDate       TDateTime , --
    IN inClientId      Integer ,
    IN inIsErased      Boolean ,
    IN inSession       TVarChar   -- ������ ������������
)
RETURNS TABLE (MovementId Integer
             , Id         Integer
             , GoodsId    Integer
             , GoodsCode  Integer
             , GoodsName  TVarChar
             , Article    TVarChar
             , Amount     TFloat 
             , AmountRemains TFloat
             , OperPrice  TFloat
             , SummMVAT   TFloat 
             , SummPVAT   TFloat
             , Summ�_VAT  TFloat
             , Comment    TVarChar
             , Ord Integer
             , isErased   Boolean
             )
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbReceiptNumber Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Movement_Cash());
     vbUserId := lpGetUserBySession (inSession);

     -- !!!�������� ������!!!
     IF inEndDate < CURRENT_DATE THEN inEndDate:= CURRENT_DATE; END IF;


     -- ���������
     RETURN QUERY
      WITH
       tmpStatus AS (SELECT zc_Enum_Status_Complete()   AS StatusId
               UNION SELECT zc_Enum_Status_UnComplete() AS StatusId
               UNION SELECT zc_Enum_Status_Erased()     AS StatusId WHERE inIsErased = TRUE
                    )

     , tmpMovement AS (SELECT Movement.*
                            , COALESCE (MovementLinkObject_Object.ObjectId, 0) AS ObjectId
                      FROM tmpStatus
                           INNER JOIN Movement ON Movement.StatusId = tmpStatus.StatusId
                                              AND Movement.DescId = zc_Movement_Invoice()
                                              AND Movement.OperDate BETWEEN inStartDate AND inEndDate
                           LEFT JOIN MovementLinkObject AS MovementLinkObject_Object
                                                        ON MovementLinkObject_Object.MovementId = Movement.Id
                                                       AND MovementLinkObject_Object.DescId = zc_MovementLinkObject_Object()
                      WHERE MovementLinkObject_Object.ObjectId = inClientId
                        OR COALESCE (inClientId, 0) = 0
                      )
     , tmpMI AS (SELECT MovementItem.*
                 FROM MovementItem
                 WHERE MovementItem.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                                   AND MovementItem.DescId = zc_MI_Master()
                                   AND (MovementItem.isErased = inIsErased OR inIsErased = TRUE)
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
                      HAVING Sum(Container.Amount) <> 0
                     )

       -- ���������
       SELECT Movement.Id                     AS MovementId
            , MovementItem.Id                 AS Id
            , MovementItem.ObjectId           AS GoodsId
            , Object_Goods.ObjectCode         AS GoodsCode
            , Object_Goods.ValueData          AS GoodsName
            , ObjectString_Article.ValueData  AS Article
            , MovementItem.Amount         ::TFloat AS Amount
              -- ������� �� ��. ������
          --, CASE WHEN Movement.StatusId = zc_Enum_Status_UnComplete() THEN COALESCE (tmpRemains.Remains,0) - COALESCE (MovementItem.Amount,0) ELSE tmpRemains.Remains END  ::TFloat AS AmountRemains 
            , tmpRemains.Remains         ::TFloat AS AmountRemains 
            --���� ��� ���
            , MIFloat_OperPrice.ValueData ::TFloat AS OperPrice  
             --����� ��� ���
            , COALESCE (MIFloat_SummMVAT.ValueData
                     , (COALESCE (MovementItem.Amount,0) * COALESCE (MIFloat_OperPrice.ValueData, 0))
                        )  ::TFloat AS SummMVAT
            -- ����� � ���
            , COALESCE (MIFloat_SummPVAT.ValueData
                      , zfCalc_SummWVAT_4 ((COALESCE (MovementItem.Amount,0) * COALESCE (MIFloat_OperPrice.ValueData, 0)) ::TFloat, MovementFloat_VATPercent.ValueData)
                        )  ::TFloat AS SummPVAT  
            --����� ���
            , ( COALESCE (MIFloat_SummPVAT.ValueData, zfCalc_SummWVAT_4 ((COALESCE (MovementItem.Amount,0) * COALESCE (MIFloat_OperPrice.ValueData, 0))::TFloat, MovementFloat_VATPercent.ValueData)) 
             -  COALESCE (MIFloat_SummMVAT.ValueData, (COALESCE (MovementItem.Amount,0) * COALESCE (MIFloat_OperPrice.ValueData, 0))) ) ::TFloat AS Summ�_VAT 

            --, (COALESCE (MovementItem.Amount,0) * COALESCE (MIFloat_OperPrice.ValueData, 0)) ::TFloat AS Summ� 
            --, zfCalc_SummWVAT_4 (COALESCE (MovementItem.Amount,0) * COALESCE (MIFloat_OperPrice.ValueData, 0), MovementFloat_VATPercent.ValueData) ::TFloat Summ�_WVAT
            --, (zfCalc_SummWVAT_4 (COALESCE (MovementItem.Amount,0) * COALESCE (MIFloat_OperPrice.ValueData, 0),MovementFloat_VATPercent.ValueData) -  (COALESCE (MovementItem.Amount,0) * COALESCE (MIFloat_OperPrice.ValueData, 0))) ::TFloat Summ�_VAT 

            --, CASE WHEN vbUserId = 5 THEN LENGTH (MIString_Comment.ValueData) :: TVarChar ELSE MIString_Comment.ValueData END :: TVarChar  AS Comment
            , LEFT (MIString_Comment.ValueData, 125) :: TVarChar AS Comment
            , ROW_NUMBER() OVER (ORDER BY MovementItem.Id ASC) :: Integer AS Ord
            , MovementItem.isErased           AS isErased
            
       FROM tmpMovement AS Movement 
            LEFT JOIN MovementFloat AS MovementFloat_VATPercent
                                    ON MovementFloat_VATPercent.MovementId = Movement.Id
                                   AND MovementFloat_VATPercent.DescId = zc_MovementFloat_VATPercent()

            INNER JOIN tmpMI AS MovementItem ON MovementItem.MovementId = Movement.Id

            LEFT JOIN MovementItemFloat AS MIFloat_OperPrice
                                        ON MIFloat_OperPrice.MovementItemId = MovementItem.Id
                                       AND MIFloat_OperPrice.DescId         = zc_MIFloat_OperPrice() 

            LEFT JOIN MovementItemFloat AS MIFloat_SummMVAT                                        
                                        ON MIFloat_SummMVAT.MovementItemId = MovementItem.Id
                                       AND MIFloat_SummMVAT.DescId         = zc_MIFloat_SummMVAT()  --����� ��� ���
            LEFT JOIN MovementItemFloat AS MIFloat_SummPVAT
                                        ON MIFloat_SummPVAT.MovementItemId = MovementItem.Id
                                       AND MIFloat_SummPVAT.DescId         = zc_MIFloat_SummPVAT() -- ����� � ���

            LEFT JOIN MovementItemString AS MIString_Comment
                                         ON MIString_Comment.MovementItemId = MovementItem.Id
                                        AND MIString_Comment.DescId = zc_MIString_Comment()

            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id     = MovementItem.ObjectId
                                            AND Object_Goods.DescId = zc_Object_Goods()

            LEFT JOIN ObjectString AS ObjectString_Article
                                   ON ObjectString_Article.ObjectId = MovementItem.ObjectId
                                  AND ObjectString_Article.DescId   = zc_ObjectString_Article()

            LEFT JOIN tmpRemains ON tmpRemains.GoodsId = Object_Goods.Id
-- where vbUserId <> 5 -- or Movement.Id = 6187
-- or Movement.Id <> 6163
          ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 12.04.24         *
 07.12.23         *
*/

-- ����
-- SELECT * FROM gpSelect_Movement_Invoice_Item (inStartDate:= '01.01.2021', inEndDate:= '18.02.2021', inClientId:= 0, inIsErased:= FALSE, inSession:= zfCalc_UserAdmin());
