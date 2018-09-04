     WITH tmpContainer AS (SELECT CLO_Member.ContainerId AS Id, Container.Amount, Container.ObjectId, CLO_Member.ObjectId AS MemberId, CLO_InfoMoney.ObjectId AS InfoMoneyId, CLO_Branch.ObjectId AS BranchId
, CLO_Car.ObjectId  as CarId
, Object_InfoMoney_View.*
                  FROM ContainerLinkObject AS CLO_Member
                  INNER JOIN Container ON Container.Id = CLO_Member.ContainerId AND Container.DescId = zc_Container_Summ()
                  LEFT JOIN ContainerLinkObject AS CLO_InfoMoney
                                                ON CLO_InfoMoney.ContainerId = Container.Id AND CLO_InfoMoney.DescId = zc_ContainerLinkObject_InfoMoney()
                  LEFT JOIN ContainerLinkObject AS CLO_Branch
                                                ON CLO_Branch.ContainerId = Container.Id AND CLO_Branch.DescId = zc_ContainerLinkObject_Branch()
                  LEFT JOIN ContainerLinkObject AS CLO_Goods
                                                ON CLO_Goods.ContainerId = Container.Id AND CLO_Goods.DescId = zc_ContainerLinkObject_Goods()

                  LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = CLO_InfoMoney.ObjectId

               LEFT JOIN ContainerLinkObject AS CLO_Car
                                             ON CLO_Car.ContainerId = Container.Id
                                            AND CLO_Car.DescId = zc_ContainerLinkObject_Car()

                  WHERE CLO_Member.DescId = zc_ContainerLinkObject_Member()
                    AND CLO_Branch.ObjectId = 301310
-- and CLO_Member.ObjectId
                    AND (CLO_Goods.ObjectId IS  NULL)
                  )
, tmp1 as (
select tmpContainer.MemberId, tmpContainer.CarId, abs (sum (MIContainer.Amount)) as amount
, DATE_TRUNC ('MONTH', MIContainer.OperDate ) as OperDate
from tmpContainer
                      inner JOIN MovementItemContainer AS MIContainer
                                                     ON MIContainer.ContainerId = tmpContainer.Id
and MIContainer.Amount < 0                                                    
where CarId > 0

group by tmpContainer.MemberId, tmpContainer.CarId
, DATE_TRUNC ('MONTH', MIContainer.OperDate ) 
)

, tmp2 as (select * 
         , ROW_NUMBER() OVER (PARTITION BY MemberId, OperDate ORDER BY amount DESC) AS Ord
from tmp1 )

, tmp_res as (select * from tmp2 where ord = 1)


, tmpMember_Car AS (SELECT ObjectLink_Personal_Member.ChildObjectId AS MemberId
                                 , Object_Car.Id              AS CarId
                                 , Object_Car.ValueData       AS CarName
                                 , Object_CarModel.ValueData  AS CarModelName
                                 , Object_Unit.ValueData      AS UnitName
                                   -- π Ô/Ô
                                 , ROW_NUMBER() OVER (PARTITION BY ObjectLink_Personal_Member.ChildObjectId ORDER BY Object_Car.Id DESC) AS Ord
                            FROM ObjectLink AS ObjectLink_Car_PersonalDriver
                                 INNER JOIN Object AS Object_Car ON Object_Car.Id       = ObjectLink_Car_PersonalDriver.ObjectId
                                                                AND Object_Car.isErased = FALSE
                                 INNER JOIN ObjectLink AS ObjectLink_Personal_Member
                                                       ON ObjectLink_Personal_Member.ObjectId = ObjectLink_Car_PersonalDriver.ChildObjectId
                                                      AND ObjectLink_Personal_Member.DescId   = zc_ObjectLink_Personal_Member()
                                 LEFT JOIN ObjectLink AS ObjectLink_Car_CarModel
                                                      ON ObjectLink_Car_CarModel.ObjectId = Object_Car.Id
                                                     AND ObjectLink_Car_CarModel.DescId   = zc_ObjectLink_Car_CarModel()
                                 LEFT JOIN Object AS Object_CarModel ON Object_CarModel.Id = ObjectLink_Car_CarModel.ChildObjectId
                                 LEFT JOIN ObjectLink AS ObjectLink_Car_Unit 
                                                      ON ObjectLink_Car_Unit.ObjectId = Object_Car.Id
                                                     AND ObjectLink_Car_Unit.DescId   = zc_ObjectLink_Car_Unit()
                                 LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = ObjectLink_Car_Unit.ChildObjectId
                            WHERE ObjectLink_Car_PersonalDriver.DescId = zc_ObjectLink_Car_PersonalDriver()
                           )
, Res as (
 -- select distinct Movement.Id, Movement.StatusId
 select tmp_res.CarId, tmpMember_Car.CarId
, *
-- , lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Car(), MovementItem.Id, coalesce (tmp_res.CarId, tmpMember_Car.CarId))

       FROM Movement

            INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                   AND MovementItem.DescId = zc_MI_Master()

            inner JOIN MovementItemLinkObject AS MILinkObject_MoneyPlace
                                         ON MILinkObject_MoneyPlace.MovementItemId = MovementItem.Id
                                        AND MILinkObject_MoneyPlace.DescId = zc_MILinkObject_MoneyPlace()
            inner JOIN Object AS Object_MoneyPlace ON Object_MoneyPlace.Id = MILinkObject_MoneyPlace.ObjectId
                             and Object_MoneyPlace.DescId = zc_Object_Member()


            left JOIN tmp_res  on tmp_res.MemberId = MILinkObject_MoneyPlace.ObjectId
                              and tmp_res.OperDate = DATE_TRUNC ('MONTH', Movement.OperDate)
            left JOIN tmpMember_Car on tmpMember_Car.MemberId = MILinkObject_MoneyPlace.ObjectId
                                   and tmpMember_Car.ord = 1
            --
where Movement.DescId = zc_Movement_Cash()
      AND Movement.AccessKeyId = zc_Enum_Process_AccessKey_CashZaporozhye()
and coalesce (tmp_res.CarId, tmpMember_Car.CarId) > 0
-- and Movement.Id = 6535167 -- 8678;"¿≈ 41-94 ¿“"
)

select *
-- , gpReComplete_Movement_Cash (Id, '5') 
from Res
where StatusId = zc_Enum_Status_Complete()


-- select * from gpGet_Movement_Cash(inMovementId := 6535167 , inOperDate := ('31.12.2017')::TDateTime , inCashId := 301799 , inCurrencyId := 14461 ,  inSession := '5');
