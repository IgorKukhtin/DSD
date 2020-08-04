-- Function: gpReport_MovementCheck_DiscountExternal()

DROP FUNCTION IF EXISTS gpReport_MovementCheck_DiscountExternal (TDateTime, TDateTime, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_MovementCheck_DiscountExternal(
    IN inStartDate          TDateTime , --
    IN inEndDate            TDateTime , --
    IN inUnitId             Integer,    -- �������������
    IN inDiscountExternalId Integer,    -- �������������
    IN inSession            TVarChar    -- ������ ������������
)
RETURNS TABLE (MovementId Integer, InvNumber TVarChar, OperDate TDateTime, StatusCode Integer
             , UnitName TVarChar, MainJuridicalId Integer, MainJuridicalName TVarChar, RetailId Integer, RetailName TVarChar
             , CashRegisterName TVarChar, PaidTypeName TVarChar
             , DiscountCardName TVarChar, DiscountExternalName TVarChar

             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , Amount TFloat
             , Price TFloat
             , Summa TFloat
             , NDS TFloat
             , PriceSale TFloat
             , SummSale TFloat
             , ChangePercent TFloat
             , SummChangePercent TFloat
             , FromName TVarChar
              )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbObjectId Integer;
   DECLARE vbRetailId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_OrderInternal());
     vbUserId:= lpGetUserBySession (inSession);

     -- ������������ <�������� ����>
     vbObjectId:= lpGet_DefaultValue ('zc_Object_Retail', vbUserId);

     -- ���������� �������� ���� ��������� �������������
     vbRetailId:= CASE WHEN vbUserId IN (3, 183242, 375661) -- ����� + ���� + ���
                          OR vbUserId IN (SELECT UserId FROM ObjectLink_UserRole_View WHERE RoleId IN (393039)) -- ������� ��������
                       THEN vbObjectId
                  ELSE
                  (SELECT ObjectLink_Juridical_Retail.ChildObjectId
                   FROM ObjectLink AS ObjectLink_Unit_Juridical
                      INNER JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                            ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                                           AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                   WHERE (ObjectLink_Unit_Juridical.ObjectId = inUnitId or COALESCE(inUnitId, 0) = 0)
                     AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                   LIMIT 1
                   )
                   END;

     -- ���������
     RETURN QUERY
         SELECT
             Movement_Check.Id
           , Movement_Check.InvNumber
           , Movement_Check.OperDate
           , Object_Status.ObjectCode                           AS StatusCode

           , Object_Unit.ValueData                              AS UnitName
           , Object_MainJuridical.Id                            AS MainJuridicalId
           , Object_MainJuridical.ValueData                     AS MainJuridicalName
           , Object_Retail.ID                                   AS RetailId
           , Object_Retail.ValueData                            AS RetailName
           , Object_CashRegister.ValueData                      AS CashRegisterName
           , Object_PaidType.ValueData                          AS PaidTypeName

           , Object_DiscountCard.ValueData                      AS DiscountCardName
           , Object_DiscountExternal.ValueData                  AS DiscountExternalName

           , MovementItem.GoodsId
           , MovementItem.GoodsCode
           , MovementItem.GoodsName
           , (-1.0 * MovementItemContainer.Amount) :: TFloat
           , MovementItem.Price
           , (MovementItem.AmountSumm * (-1.0 * MovementItemContainer.Amount)/ MovementItem.Amount) :: TFloat
           , MovementItem.NDS
           , MovementItem.PriceSale
           , (MovementItem.PriceSale * (-1.0 * MovementItemContainer.Amount)) :: TFloat AS SummSale
           , MovementItem.ChangePercent
           ,( MovementItem.SummChangePercent * (-1.0 * MovementItemContainer.Amount)/ MovementItem.Amount) :: TFloat
           , Object_From.ValueData                      AS FromName

        FROM (SELECT Movement.*
                   , MovementLinkObject_Unit.ObjectId                    AS UnitId
                   , MovementLinkObject_DiscountCard.ObjectId            AS DiscountCardID
                   , ObjectLink_DiscountExternal.ChildObjectId           AS DiscountExternalId
              FROM Movement


                   INNER JOIN MovementLinkObject AS MovementLinkObject_DiscountCard
                                                 ON MovementLinkObject_DiscountCard.MovementId = Movement.ID
                                                AND MovementLinkObject_DiscountCard.DescId = zc_MovementLinkObject_DiscountCard()

                   INNER JOIN ObjectLink AS ObjectLink_DiscountExternal
                                         ON ObjectLink_DiscountExternal.ObjectId = MovementLinkObject_DiscountCard.ObjectId
                                        AND ObjectLink_DiscountExternal.DescId = zc_ObjectLink_DiscountCard_Object()

                   INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                ON MovementLinkObject_Unit.MovementId = Movement.Id
                                               AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()

              WHERE Movement.OperDate >= DATE_TRUNC ('DAY', inStartDate)
                AND Movement.OperDate < DATE_TRUNC ('DAY', inEndDate) + INTERVAL '1 DAY'
                AND Movement.DescId = zc_Movement_Check()
                AND (ObjectLink_DiscountExternal.ChildObjectId = inDiscountExternalId
                 OR COALESCE (ObjectLink_DiscountExternal.ChildObjectId, 0) <> 0 AND COALESCE (inDiscountExternalId, 0) = 0)
                AND (MovementLinkObject_Unit.ObjectId = inUnitId OR COALESCE (inUnitId, 0) = 0)
                AND  Movement.StatusId = zc_Enum_Status_Complete()
--                AND vbRetailId = vbObjectId
           ) AS Movement_Check

             LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement_Check.StatusId

             LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = Movement_Check.UnitId

             LEFT JOIN ObjectLink AS ObjectLink_Unit_Juridical
                                  ON ObjectLink_Unit_Juridical.ObjectId = Movement_Check.UnitId
                                 AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
             LEFT JOIN Object AS Object_MainJuridical ON Object_MainJuridical.Id = ObjectLink_Unit_Juridical.ChildObjectId

             LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                  ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                                 AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
             LEFT JOIN Object AS Object_Retail ON Object_Retail.Id = ObjectLink_Juridical_Retail.ChildObjectId

             LEFT JOIN MovementLinkObject AS MovementLinkObject_CashRegister
                                          ON MovementLinkObject_CashRegister.MovementId = Movement_Check.Id
                                         AND MovementLinkObject_CashRegister.DescId = zc_MovementLinkObject_CashRegister()
             LEFT JOIN Object AS Object_CashRegister ON Object_CashRegister.Id = MovementLinkObject_CashRegister.ObjectId

             LEFT JOIN Object AS Object_DiscountCard ON Object_DiscountCard.Id = Movement_Check.DiscountCardId
             LEFT JOIN Object AS Object_DiscountExternal ON Object_DiscountExternal.Id = Movement_Check.DiscountExternalId


   	         LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidType
                                          ON MovementLinkObject_PaidType.MovementId = Movement_Check.Id
                                         AND MovementLinkObject_PaidType.DescId = zc_MovementLinkObject_PaidType()
             LEFT JOIN Object AS Object_PaidType ON Object_PaidType.Id = MovementLinkObject_PaidType.ObjectId

             LEFT JOIN MovementItem_Check_View AS MovementItem
                                               ON MovementItem.MovementId = Movement_Check.Id
                                              AND MovementItem.Amount > 0 
                                               
             LEFT JOIN MovementItemContainer ON MovementItemContainer.MovementItemId = MovementItem.ID

             LEFT JOIN ContainerLinkObject AS CLI_MI
                                           ON CLI_MI.ContainerId = MovementItemContainer.ContainerId
                                          AND CLI_MI.DescId = zc_ContainerLinkObject_PartionMovementItem()
             LEFT OUTER JOIN Object AS Object_PartionMovementItem ON Object_PartionMovementItem.Id = CLI_MI.ObjectId
             -- ������� �������
             LEFT JOIN MovementItem AS MI_Income ON MI_Income.Id = Object_PartionMovementItem.ObjectCode
             -- ���� ��� ������, ������� ���� ������� ��������������� - � ���� �������� ����� "���������" ��������� ������ �� ����������
             LEFT JOIN MovementItemFloat AS MIFloat_MovementItem
                                         ON MIFloat_MovementItem.MovementItemId = MI_Income.Id
                                        AND MIFloat_MovementItem.DescId = zc_MIFloat_MovementItemId()
             -- �������� ������� �� ���������� (���� ��� ������, ������� ���� ������� ���������������)
             LEFT JOIN MovementItem AS MI_Income_find ON MI_Income_find.Id  = (MIFloat_MovementItem.ValueData :: Integer)
                                                  -- AND 1=0

             LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                          ON MovementLinkObject_From.MovementId = COALESCE (MI_Income_find.MovementId,MI_Income.MovementId)
                                         AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()

             LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId
             ;


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 29.10.19                                                       *
*/

