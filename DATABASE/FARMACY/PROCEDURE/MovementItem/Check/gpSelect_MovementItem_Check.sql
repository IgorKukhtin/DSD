-- Function: gpSelect_MovementItem_Income()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_Check (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_Check(
    IN inMovementId  Integer      , -- ���� ���������
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, ParentId integer
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , IntenalSPName TVarChar
             , Amount TFloat
             , Price TFloat
             , Summ TFloat
             , NDS TFloat
             , PriceSale TFloat
             , SummSale TFloat
             , ChangePercent TFloat
             , SummChangePercent TFloat
             , AmountOrder TFloat
             , DiscountExternalId Integer
             , DiscountExternalName TVarChar
             , List_UID TVarChar
             , isErased Boolean
             , isSp Boolean
             , Remains TFloat
             , Color_calc Integer
             , Color_ExpirationDate Integer   
             , AccommodationName TVarChar
             , Multiplicity TFloat
             , DoesNotShare Boolean
             , IdSP TVarChar
             , CountSP TFloat
             , PriceRetSP TFloat
             , PaymentSP TFloat
             , PartionDateKindId Integer, PartionDateKindName TVarChar
             , NDSKindId Integer
              )
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbMovementId_SP Integer;
BEGIN

     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_Income());
     vbUserId := inSession;

     vbMovementId_SP := (SELECT Movement.Id
                         FROM Movement 
                              LEFT JOIN MovementString AS MovementString_InvNumberSP
                                     ON MovementString_InvNumberSP.MovementId = Movement.Id
                                    AND MovementString_InvNumberSP.DescId = zc_MovementString_InvNumberSP()
                              LEFT JOIN MovementString AS MovementString_MedicSP
                                     ON MovementString_MedicSP.MovementId = Movement.Id
                                    AND MovementString_MedicSP.DescId = zc_MovementString_MedicSP()
                              LEFT JOIN MovementString AS MovementString_Ambulance
                                     ON MovementString_Ambulance.MovementId = Movement.Id
                                    AND MovementString_Ambulance.DescId = zc_MovementString_Ambulance()
                              LEFT JOIN MovementLinkObject AS MovementLinkObject_PartnerMedical
                                         ON MovementLinkObject_PartnerMedical.MovementId = Movement.Id
                                        AND MovementLinkObject_PartnerMedical.DescId = zc_MovementLinkObject_PartnerMedical()
                          WHERE Movement.Id = inMovementId
                            AND Movement.DescId = zc_Movement_Check()
                            AND ( COALESCE(MovementString_InvNumberSP.ValueData,'') <> '' 
                               OR COALESCE(MovementString_MedicSP.ValueData,'') <> '' 
                               OR COALESCE(MovementString_Ambulance.ValueData,'') <> '' 
                               OR COALESCE(MovementLinkObject_PartnerMedical.ObjectId,0) <> 0)  
                          );   

     RETURN QUERY
     WITH
     tmpMI AS (SELECT MovementItem.*
               FROM MovementItem_Check_View AS MovementItem
               WHERE MovementItem.MovementId = inMovementId
               )

   , tmpMIFloat_ContainerId AS (SELECT MovementItemFloat.MovementItemId
                                     , MovementItemFloat.ValueData :: Integer AS ContainerId
                                FROM MovementItemFloat
                                WHERE MovementItemFloat.MovementItemId IN (SELECT tmpMI.Id FROM tmpMI)
                                  AND MovementItemFloat.DescId = zc_MIFloat_ContainerId()
                                )
    --
   , tmpContainer AS (SELECT tmp.ContainerId
                           , COALESCE (MI_Income_find.MovementId,MI_Income.MovementId) AS MovementId_Income
                           , COALESCE (MIDate_ExpirationDate.ValueData, zc_DateEnd())  AS ExpirationDate
                      FROM tmpMIFloat_ContainerId AS tmp
                           LEFT JOIN ContainerlinkObject AS ContainerLinkObject_MovementItem
                                                         ON ContainerLinkObject_MovementItem.Containerid = tmp.ContainerId
                                                        AND ContainerLinkObject_MovementItem.DescId = zc_ContainerLinkObject_PartionMovementItem()
                           LEFT OUTER JOIN Object AS Object_PartionMovementItem ON Object_PartionMovementItem.Id = ContainerLinkObject_MovementItem.ObjectId
                           -- ������� �������
                           LEFT JOIN MovementItem AS MI_Income ON MI_Income.Id = Object_PartionMovementItem.ObjectCode
                           -- ���� ��� ������, ������� ���� ������� ��������������� - � ���� �������� ����� "���������" ��������� ������ �� ����������
                           LEFT JOIN MovementItemFloat AS MIFloat_MovementItem
                                                       ON MIFloat_MovementItem.MovementItemId = MI_Income.Id
                                                      AND MIFloat_MovementItem.DescId = zc_MIFloat_MovementItemId()
                           -- �������� ������� �� ���������� (���� ��� ������, ������� ���� ������� ���������������)
                           LEFT JOIN MovementItem AS MI_Income_find ON MI_Income_find.Id = (MIFloat_MovementItem.ValueData :: Integer)
                                      
                           LEFT OUTER JOIN MovementItemDate  AS MIDate_ExpirationDate
                                                             ON MIDate_ExpirationDate.MovementItemId = COALESCE (MI_Income_find.Id,MI_Income.Id)  --Object_PartionMovementItem.ObjectCode
                                                            AND MIDate_ExpirationDate.DescId = zc_MIDate_PartionGoods()
                     )
    --
   , tmpPartion AS (SELECT Movement.Id
                         , MovementDate_Branch.ValueData AS BranchDate
                         , Movement.Invnumber            AS Invnumber
                         , Object_From.ValueData         AS FromName
                         , Object_Contract.ValueData     AS ContractName
                    FROM Movement
                         LEFT JOIN MovementDate AS MovementDate_Branch
                                                ON MovementDate_Branch.MovementId = Movement.Id
                                               AND MovementDate_Branch.DescId = zc_MovementDate_Branch()

                         LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                      ON MovementLinkObject_From.MovementId = Movement.Id
                                                     AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                         LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId

                         LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                                      ON MovementLinkObject_Contract.MovementId = Movement.Id
                                                     AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
                         LEFT JOIN Object AS Object_Contract ON Object_Contract.Id = MovementLinkObject_Contract.ObjectId
                    WHERE Movement.Id IN (SELECT DISTINCT tmpContainer.MovementId_Income FROM tmpContainer)
                    )

   , tmpMILO_PartionDateKind AS (SELECT MovementItemLinkObject.*
                                 FROM MovementItemLinkObject
                                 WHERE MovementItemLinkObject.MovementItemId IN (SELECT DISTINCT tmpMI.Id FROM tmpMI)
                                   AND MovementItemLinkObject.DescId IN (zc_MILinkObject_PartionDateKind(), zc_MILinkObject_DiscountExternal())
                                )
   , tmpNDSKind AS (SELECT ObjectFloat_NDSKind_NDS.ObjectId
                         , ObjectFloat_NDSKind_NDS.ValueData
                   FROM ObjectFloat AS ObjectFloat_NDSKind_NDS
                   WHERE ObjectFloat_NDSKind_NDS.DescId = zc_ObjectFloat_NDSKind_NDS()
                  )

       SELECT
             MovementItem.Id
           , MovementItem.ParentId  
           , MovementItem.GoodsId
           , MovementItem.GoodsCode
           , MovementItem.GoodsName
           , Object_IntenalSP.ValueData AS IntenalSPName
           , MovementItem.Amount
           , MovementItem.Price
           , MovementItem.AmountSumm
           , MovementItem.NDS
           , MovementItem.PriceSale
           , (MovementItem.PriceSale * MovementItem.Amount) :: TFloat AS SummSale
           , MovementItem.ChangePercent
           , MovementItem.SummChangePercent
           , MovementItem.AmountOrder
           , Object_DiscountExternal.ID                               AS DiscountCardId
           , Object_DiscountExternal.ValueData                        AS DiscountCardName
           , MovementItem.List_UID
           , MovementItem.isErased
           , CASE WHEN COALESCE (vbMovementId_SP,0) = 0 THEN False ELSE TRUE END AS isSp
           , MovementItem.Amount
           , zc_Color_White()                                                    AS Color_calc
           , zc_Color_Black()                                                    AS Color_ExpirationDate
           , Null::TVArChar                                                      AS AccommodationName  
           , Null::TFloat                                                        AS Multiplicity 

           , COALESCE (ObjectBoolean_DoesNotShare.ValueData, FALSE)              AS DoesNotShare
           , Null::TVArChar                                                      AS IdSP  
           , Null::TFloat                                                        AS CountSP 
           , Null::TFloat                                                        AS PriceRetSP
           , Null::TFloat                                                        AS PaymentSP

           , Object_PartionDateKind.Id                    AS PartionDateKindId
           , Object_PartionDateKind.ValueData :: TVarChar AS PartionDateKindName

           , MovementItem.NDSKindId                       AS NDSKindId

           /*, MIFloat_ContainerId.ContainerId  ::TFloat                         AS ContainerId
           , COALESCE (tmpContainer.ExpirationDate, NULL)      :: TDateTime      AS ExpirationDate
           , COALESCE (tmpPartion.BranchDate, NULL)            :: TDateTime      AS OperDate_Income
           , COALESCE (tmpPartion.Invnumber, NULL)             :: TVarChar       AS Invnumber_Income
           , COALESCE (tmpPartion.FromName, NULL)              :: TVarChar       AS FromName_Income
           , COALESCE (tmpPartion.ContractName, NULL)          :: TVarChar       AS ContractName_Income
           */
       FROM tmpMI AS MovementItem 
            -- �������� GoodsMainId
            LEFT JOIN  ObjectLink AS ObjectLink_Child 
                                  ON ObjectLink_Child.ChildObjectId = MovementItem.GoodsId
                                 AND ObjectLink_Child.DescId = zc_ObjectLink_LinkGoods_Goods()
            LEFT JOIN  ObjectLink AS ObjectLink_Main 
                                  ON ObjectLink_Main.ObjectId = ObjectLink_Child.ObjectId
                                 AND ObjectLink_Main.DescId = zc_ObjectLink_LinkGoods_GoodsMain()
            LEFT JOIN ObjectLink AS ObjectLink_Goods_IntenalSP
                                 ON ObjectLink_Goods_IntenalSP.ObjectId = ObjectLink_Main.ChildObjectId 
                                AND ObjectLink_Goods_IntenalSP.DescId = zc_ObjectLink_Goods_IntenalSP()
            LEFT JOIN Object AS Object_IntenalSP ON Object_IntenalSP.Id = ObjectLink_Goods_IntenalSP.ChildObjectId

            -- 

            LEFT JOIN tmpMILO_PartionDateKind AS MILinkObject_PartionDateKind
                                              ON MILinkObject_PartionDateKind.MovementItemId = MovementItem.Id
                                             AND MILinkObject_PartionDateKind.DescId         = zc_MILinkObject_PartionDateKind()
            LEFT JOIN Object AS Object_PartionDateKind ON Object_PartionDateKind.Id = MILinkObject_PartionDateKind.ObjectId

            LEFT JOIN tmpMILO_PartionDateKind AS MILinkObject_DiscountExternal
                                              ON MILinkObject_DiscountExternal.MovementItemId = MovementItem.Id
                                             AND MILinkObject_DiscountExternal.DescId         = zc_MILinkObject_DiscountExternal()
            LEFT JOIN Object AS Object_DiscountExternal ON Object_DiscountExternal.Id = MILinkObject_DiscountExternal.ObjectId

            /*LEFT JOIN tmpMIFloat_ContainerId AS MIFloat_ContainerId
                                             ON MIFloat_ContainerId.MovementItemId = MovementItem.Id
            LEFT JOIN tmpContainer ON tmpContainer.ContainerId = MIFloat_ContainerId.ContainerId
            LEFT JOIN tmpPartion ON tmpPartion.Id= tmpContainer.MovementId_Income
            */
            -- �� ������ ���������� �� ������
            LEFT JOIN ObjectBoolean AS ObjectBoolean_DoesNotShare
                                    ON ObjectBoolean_DoesNotShare.ObjectId = MovementItem.GoodsId
                                   AND ObjectBoolean_DoesNotShare.DescId = zc_ObjectBoolean_Goods_DoesNotShare()

      ;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_MovementItem_Check (Integer, TVarChar) OWNER TO postgres;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�. ��������� �.�   ������ �.�.
 21.06.20                                                                                   *  DiscountExternal
 03.06.19         *
 25.04.19                                                                                   *
 20.04.19         * 
 31.03.19                                                                                   *
 15.03.19                                                                                   *
 05.11.18                                                                                   *
 21.10.18                                                                                   *
 21.04.17         *
 10.08.16                                                                      * + MovementItem.LIST_UID
 03.08.16         *
 03.07.15                                                                       * �������� ���
 25.05.15                         *
*/

-- ����
-- select * from gpSelect_MovementItem_Check(inMovementId := 19274728  ,  inSession := '3');