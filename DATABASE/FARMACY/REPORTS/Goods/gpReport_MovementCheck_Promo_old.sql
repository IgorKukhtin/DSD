-- Function: gpSelect_Movement_PriceList()

DROP FUNCTION IF EXISTS gpReport_MovementCheck_Promo (Integer, TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_MovementCheck_Promo(
    IN inMakerId       Integer     -- �������������
  , IN inStartDate     TDateTime 
  , IN inEndDate       TDateTime
  , IN inSession       TVarChar    -- ������ ������������
)
RETURNS TABLE (MovementId Integer      --�� ���������
              ,ItemName TVarChar       --��������(���) ���������
              ,Amount TFloat           --���-�� ������ � ���������
              ,Code Integer            --��� ������
              ,Name TVarChar           --������������ ������
              ,NDSKindName TVarChar    --��� ���
              ,OperDate TDateTime      --���� ���������
              ,InvNumber TVarChar      --� ���������
              ,StatusName TVarChar     --��������� ���������
              ,UnitName TVarChar       --�������������
              ,MainJuridicalName TVarChar  --���� ��. ����
              ,JuridicalName TVarChar  --��. ����
              ,RetailName TVarChar     --�������� ����
              ,Price TFloat            --���� � ���������
              ,PriceWithVAT TFloat     --���� ������� � ��� 
              ,PriceSale TFloat        --���� �������
              ,Comment  TVarChar       --����������� � ���������
              ,PartionGoods TVarChar   --� ����� ���������
              ,ExpirationDate TDateTime--���� ��������
              ,InsertDate TDateTime    --���� (����.)
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_PriceList());
    vbUserId:= lpGetUserBySession (inSession);
 
    RETURN QUERY
      WITH
        -- ��� ��������� ����� � ������ , ���./ ������. ���� �������� 
          -- ������ �� ������������� ����������
          tmpGoodsPromo AS (SELECT DISTINCT
                                   MI_Goods.ObjectId  AS GoodsId        -- ����� �����
                                 , MovementDate_StartPromo.ValueData  AS StartDate_Promo
                                 , MovementDate_EndPromo.ValueData    AS EndDate_Promo 
                            FROM Movement
                              INNER JOIN MovementLinkObject AS MovementLinkObject_Maker
                                                            ON MovementLinkObject_Maker.MovementId = Movement.Id
                                                           AND MovementLinkObject_Maker.DescId = zc_MovementLinkObject_Maker()
                                                           AND MovementLinkObject_Maker.ObjectId = inMakerId
                              INNER JOIN MovementDate AS MovementDate_StartPromo
                                                      ON MovementDate_StartPromo.MovementId = Movement.Id
                                                     AND MovementDate_StartPromo.DescId = zc_MovementDate_StartPromo()
                              INNER JOIN MovementDate AS MovementDate_EndPromo
                                                      ON MovementDate_EndPromo.MovementId = Movement.Id
                                                     AND MovementDate_EndPromo.DescId = zc_MovementDate_EndPromo()
                              INNER JOIN MovementItem AS MI_Goods ON MI_Goods.MovementId = Movement.Id
                                                                 AND MI_Goods.DescId = zc_MI_Master()
                                                                 AND MI_Goods.isErased = FALSE
                            WHERE Movement.StatusId = zc_Enum_Status_Complete()
                              AND Movement.DescId = zc_Movement_Promo()
                       )
        -- ������ �����
   ,  tmpGoods_All AS (SELECT ObjectLink_Child_R.ChildObjectId  AS GoodsId        -- ����� �����
                            , tmpGoodsPromo.StartDate_Promo
                            , tmpGoodsPromo.EndDate_Promo 
                       FROM tmpGoodsPromo
                               -- !!!
                              INNER JOIN ObjectLink AS ObjectLink_Child
                                                    ON ObjectLink_Child.ChildObjectId = tmpGoodsPromo.GoodsId 
                                                   AND ObjectLink_Child.DescId        = zc_ObjectLink_LinkGoods_Goods()
                              INNER JOIN ObjectLink AS ObjectLink_Main ON ObjectLink_Main.ObjectId = ObjectLink_Child.ObjectId
                                                                      AND ObjectLink_Main.DescId   = zc_ObjectLink_LinkGoods_GoodsMain()
                              INNER JOIN ObjectLink AS ObjectLink_Main_R ON ObjectLink_Main_R.ChildObjectId = ObjectLink_Main.ChildObjectId
                                                                        AND ObjectLink_Main_R.DescId        = zc_ObjectLink_LinkGoods_GoodsMain()
                              INNER JOIN ObjectLink AS ObjectLink_Child_R ON ObjectLink_Child_R.ObjectId = ObjectLink_Main_R.ObjectId
                                                                         AND ObjectLink_Child_R.DescId   = zc_ObjectLink_LinkGoods_Goods()
                        WHERE  ObjectLink_Child_R.ChildObjectId<>0
                      ) 
    ,   tmpGoods AS (SELECT DISTINCT tmpGoods_All.GoodsId FROM tmpGoods_All)

            -- �������� ��� ���� � �������� �������������� ���������
         ,   tmpMI_1 AS (SELECT MIContainer.ContainerId
                              , MIContainer.MovementItemId
                              , Movement_Check.Id                   AS MovementId_Check
                              , MovementLinkObject_Unit.ObjectId    AS UnitId
                              , MIContainer.ObjectId_Analyzer   AS GoodsId
                              , SUM (COALESCE (-1 * MIContainer.Amount, 0)) AS Amount
                             -- , SUM (COALESCE (-1 * MIContainer.Amount, 0) * COALESCE (MIFloat_Price.ValueData, 0)) AS SummaSale
                         FROM Movement AS Movement_Check
                              INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                            ON MovementLinkObject_Unit.MovementId = Movement_Check.Id
                                                           AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()

                              INNER JOIN MovementItemContainer AS MIContainer
                                                               ON MIContainer.MovementId = Movement_Check.Id
                                                              AND MIContainer.DescId = zc_MIContainer_Count()                                                            
                              -- ������ ������ ����.�����.
                              INNER JOIN tmpGoods ON tmpGoods.GoodsId = MIContainer.ObjectId_Analyzer

                         WHERE Movement_Check.DescId = zc_Movement_Check()
                           AND Movement_Check.OperDate >= inStartDate AND Movement_Check.OperDate < inEndDate + INTERVAL '1 DAY'
                         --  AND Movement_Check.OperDate >= '01.10.2016' AND Movement_Check.OperDate < '01.11.2016'
                           AND Movement_Check.StatusId = zc_Enum_Status_Complete()
                           AND COALESCE (inMakerId, 0) <> 0
                         GROUP BY MIContainer.ObjectId_Analyzer
                                , Movement_Check.Id
                                , MovementLinkObject_Unit.ObjectId
                                , MIContainer.ContainerId, MIContainer.MovementItemId
                         HAVING SUM (COALESCE (-1 * MIContainer.Amount, 0)) <> 0
                         )

           ,   tmpMI AS (SELECT tmpMI_1.ContainerId
                              , tmpMI_1.MovementId_Check
                              , tmpMI_1.UnitId
                              , tmpMI_1.GoodsId
                              , SUM (COALESCE (tmpMI_1.Amount, 0)) AS Amount
                              , SUM (COALESCE (tmpMI_1.Amount, 0) * COALESCE (MIFloat_Price.ValueData, 0)) AS SummaSale
                         FROM tmpMI_1
                              LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                          ON MIFloat_Price.MovementItemId = tmpMI_1.MovementItemId
                                                         AND MIFloat_Price.DescId = zc_MIFloat_Price()
                         GROUP BY tmpMI_1.ContainerId
                                , tmpMI_1.MovementId_Check
                                , tmpMI_1.UnitId
                                , tmpMI_1.GoodsId
                         )

         -- tmpData_01/tmpData_02/tmpData_03  �������� ����� � ��������
        , tmpData_01 AS (SELECT tmpMI.MovementId_Check
                              , tmpMI.UnitId
                              , CLO.ObjectId AS CLO_MI_ObjectId
                              , tmpMI.GoodsId
                              , (tmpMI.Amount)    AS Amount
                              , (tmpMI.SummaSale) AS SummaSale
                         FROM ContainerlinkObject AS CLO
                            INNER JOIN tmpMI ON CLO.Containerid = tmpMI.ContainerId
                        WHERE CLO.DescId = zc_ContainerLinkObject_PartionMovementItem()
                 )
  
         , tmpData_02 AS (SELECT tmpMI.MovementId_Check
                              , tmpMI.UnitId
                              , Object_PartionMovementItem.ObjectCode :: Integer  AS OPMI_ObjectCode
                              , tmpMI.GoodsId
                              , (tmpMI.Amount)    AS Amount
                              , (tmpMI.SummaSale) AS SummaSale
                         FROM tmpData_01 AS tmpMI
                              LEFT JOIN Object AS Object_PartionMovementItem ON Object_PartionMovementItem.Id = tmpMI.CLO_MI_ObjectId
                         )

         , tmpData_03 AS (SELECT tmpMI.MovementId_Check
                              , tmpMI.UnitId
                              , COALESCE (MI_Income_find.MovementId, MI_Income.MovementId) :: Integer AS MovementId
                              , COALESCE (MI_Income_find.Id,         MI_Income.Id)         :: Integer AS MovementItemId_Income
                              , tmpMI.GoodsId
                              , (tmpMI.Amount)    AS Amount
                              , (tmpMI.SummaSale) AS SummaSale
                         FROM tmpData_02 AS tmpMI
                              -- ������� �������
                              LEFT JOIN MovementItem AS MI_Income ON MI_Income.Id = tmpMI.OPMI_ObjectCode
                              -- ���� ��� ������, ������� ���� ������� ��������������� - � ���� �������� ����� "���������" ��������� ������ �� ����������
                              LEFT JOIN MovementItemFloat AS MIFloat_MovementItem
                                                          ON MIFloat_MovementItem.MovementItemId = MI_Income.Id
                                                         AND MIFloat_MovementItem.DescId = zc_MIFloat_MovementItemId()
                              -- �������� ������� �� ���������� (���� ��� ������, ������� ���� ������� ���������������)
                              LEFT JOIN MovementItem AS MI_Income_find ON MI_Income_find.Id = (MIFloat_MovementItem.ValueData :: Integer)
                  )
   
       -- ����� ������������ �������� �������������� ���������
       , tmpData_all AS (SELECT tmp.MovementId_Check
                              , tmp.UnitId 
                              , tmp.MovementItemId_Income
                              , tmp.GoodsId
                              , tmp.Amount
                              , tmp.SummaSale
                              , MovementLinkObject_From_Income.ObjectId AS JuridicalId_Income
                         FROM tmpData_03 AS tmp
                              INNER JOIN Movement AS Movement_Income ON Movement_Income.Id = tmp.MovementId
                              -- ���������, ��� �������� ������� �� ���������� (��� NULL)
                              INNER JOIN MovementLinkObject AS MovementLinkObject_From_Income
                                                            ON MovementLinkObject_From_Income.MovementId = tmp.MovementId
                                                           AND MovementLinkObject_From_Income.DescId     = zc_MovementLinkObject_From()
                                                    
                              INNER JOIN tmpGoods_All ON tmpGoods_All.GoodsId = tmp.GoodsId
                                                     AND tmpGoods_All.StartDate_Promo <= Movement_Income.OperDate
                                                     AND tmpGoods_All.EndDate_Promo   >= Movement_Income.OperDate
                            ) 
           -- 
           , tmpData AS (SELECT tmpData_all.MovementId_Check
                              , tmpData_all.UnitId
                              , tmpData_all.JuridicalId_Income
                              , tmpData_all.GoodsId
                              , MIString_PartionGoods.ValueData          AS PartionGoods
                              , MIDate_ExpirationDate.ValueData          AS ExpirationDate
                              , SUM (tmpData_all.Amount * COALESCE (MIFloat_JuridicalPrice.ValueData, 0))  AS Summa
                              , SUM (tmpData_all.Amount * COALESCE (MIFloat_PriceWithVAT.ValueData, 0))    AS SummaWithVAT
                              , SUM (tmpData_all.Amount)    AS Amount
                              , SUM (tmpData_all.SummaSale) AS SummaSale
                         FROM tmpData_all
                              -- ���� � ������ ���, ��� �������� ������� �� ���������� (��� NULL)
                              LEFT JOIN MovementItemFloat AS MIFloat_JuridicalPrice
                                                          ON MIFloat_JuridicalPrice.MovementItemId = tmpData_all.MovementItemId_Income
                                                         AND MIFloat_JuridicalPrice.DescId = zc_MIFloat_JuridicalPrice()
                              -- ���� � ������ ���, ��� �������� ������� �� ���������� ��� % �������������  (��� NULL)
                              LEFT JOIN MovementItemFloat AS MIFloat_PriceWithVAT
                                                          ON MIFloat_PriceWithVAT.MovementItemId = tmpData_all.MovementItemId_Income
                                                         AND MIFloat_PriceWithVAT.DescId = zc_MIFloat_PriceWithVAT()
                              -- � ������ ���������
                              LEFT JOIN MovementItemString AS MIString_PartionGoods
                                                           ON MIString_PartionGoods.MovementItemId = tmpData_all.MovementItemId_Income
                                                          AND MIString_PartionGoods.DescId = zc_MIString_PartionGoods()
                              -- ���� ��������
                              LEFT JOIN MovementItemDate AS MIDate_ExpirationDate
                                                         ON MIDate_ExpirationDate.MovementItemId = tmpData_all.MovementItemId_Income
                                                        AND MIDate_ExpirationDate.DescId = zc_MIDate_PartionGoods()
                       
                         GROUP BY tmpData_all.JuridicalId_Income
                                , tmpData_all.MovementId_Check
                                , tmpData_all.GoodsId
                                , tmpData_all.UnitId
                                , MIString_PartionGoods.ValueData
                                , MIDate_ExpirationDate.ValueData
                        )

      -- ���������
      SELECT Movement.Id                              AS MovementId
            ,'������� ����'               :: TVarChar AS ItemName
            ,tmpData.Amount               :: TFloat   AS Amount
            ,Object.ObjectCode                        AS Code
            ,Object.ValueData                         AS Name
            ,Object_NDSKind.ValueData                 AS NDSKindName
            ,Movement.OperDate                        AS OperDate
            ,Movement.InvNumber                       AS InvNumber
            ,Object_Status.ValueData                  AS StatusName
            ,Object_Unit.ValueData                    AS UnitName
            ,Object_MainJuridical.ValueData           AS MainJuridicalName
            ,Object_From.ValueData                    AS JuridicalName
            ,Object_Retail.ValueData                  AS RetailName 
            ,CASE WHEN tmpData.Amount <> 0 THEN tmpData.Summa / tmpData.Amount ELSE 0 END        :: TFloat AS Price
            ,CASE WHEN tmpData.Amount <> 0 THEN tmpData.SummaWithVAT / tmpData.Amount ELSE 0 END :: TFloat AS PriceWithVAT

            ,CASE WHEN tmpData.Amount <> 0 THEN tmpData.SummaSale    / tmpData.Amount ELSE 0 END :: TFloat AS PriceSale

            ,MovementString_Comment.ValueData  :: TVarChar        AS Comment

            ,tmpData.PartionGoods
            ,tmpData.ExpirationDate
           
            ,MovementDate_Insert.ValueData            AS InsertDate

      FROM tmpData 
        LEFT JOIN Movement ON Movement.Id = tmpData.MovementId_Check
        LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId 
                   
        LEFT JOIN MovementDate AS MovementDate_Insert
                               ON MovementDate_Insert.MovementId = tmpData.MovementId_Check
                              AND MovementDate_Insert.DescId = zc_MovementDate_Insert()

        LEFT JOIN Object ON Object.Id = tmpData.GoodsId

        LEFT JOIN ObjectLink AS ObjectLink_Goods_NDSKind
                             ON ObjectLink_Goods_NDSKind.ObjectId = Object.Id
                            AND ObjectLink_Goods_NDSKind.DescId = zc_ObjectLink_Goods_NDSKind()
        LEFT JOIN Object AS Object_NDSKind ON Object_NDSKind.Id = ObjectLink_Goods_NDSKind.ChildObjectId

        LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = tmpData.UnitId
        LEFT JOIN ObjectLink AS ObjectLink_Unit_Juridical
                             ON ObjectLink_Unit_Juridical.ObjectId = Object_Unit.Id
                            AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
        LEFT JOIN Object AS Object_MainJuridical ON Object_MainJuridical.Id = ObjectLink_Unit_Juridical.ChildObjectId

        LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                             ON ObjectLink_Juridical_Retail.ObjectId = Object_MainJuridical.Id
                            AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
        LEFT JOIN Object AS Object_Retail ON Object_Retail.Id = ObjectLink_Juridical_Retail.ChildObjectId

        LEFT JOIN Object AS Object_From ON Object_From.Id = tmpData.JuridicalId_Income

        LEFT JOIN MovementString AS MovementString_Comment
                                 ON MovementString_Comment.DescId = zc_MovementString_Comment()
                                AND MovementString_Comment.MovementId = tmpData.MovementId_Check
     ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.  ��������� �.�.
 23.11.16         *
 08.11.16         *
*/

-- ����
--select * from gpReport_MovementCheck_Promo(inMakerId := 2336655 , inStartDate := ('01.11.2016')::TDateTime , inEndDate := ('30.11.2016')::TDateTime ,  inSession := '3');