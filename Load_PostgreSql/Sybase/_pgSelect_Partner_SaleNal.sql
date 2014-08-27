-- Int - Partner_SaleNal
alter PROCEDURE "DBA"."_pgSelect_Partner_SaleNal" (in @inStartDate date, in @inEndDate date, in @inParentId_PG_Dnepr integer)
result (ObjectId Integer, ObjectCode Integer, ObjectName TVarCharLong, ParentId_Postgres Integer
      , Address TVarCharLongLong, InfoMoneyCode integer, InfoMoneyId_PG integer, OKPO TVarCharLong, isOKPO_Virtual smallint, DayCount_Real integer, DayCount_Bank integer, Id_Postgres integer)
begin
   //
            select Unit.Id as ObjectId
                 , Unit.UnitCode as ObjectCode
                 , trim(Unit.UnitName) as ObjectName
                 , @inParentId_PG_Dnepr  as ParentId_Postgres --  Dnepr
                 , Information2.AddressFirm as Address
                 , tmpBill.InfoMoneyCode
                 , _pgInfoMoney.Id3_Postgres AS InfoMoneyId_PG
                 , isnull (Information1.OKPO, isnull (Information2.OKPO, '')) AS OKPO
                 , case when Unit.PersonalId_Postgres<>0 then zc_rvYes() else zf_isOKPO_Virtual_PG(OKPO) end as isOKPO_Virtual
                 , ClientSumm.DayCount_Real
                 , ClientSumm.DayCount_Bank
                 , isnull(Unit.Id3_Postgres,0) as Id_Postgres
            from 
           (select ClientId
                  ,InfoMoneyCode
            from
           (select ObjectId as ClientId, case when isSale=zc_rvYes() then 30101 else 0 end as InfoMoneyCode
            from _pgSelect_Bill_LossDebt
            where ClientId_pg = 0 and trim (OKPO) <> ''
           union all
           select Bill.ToId as ClientId
                  ,case when Bill.FromId in (zc_UnitId_StoreSale())
                             then 30101 -- Готовая продукция
                        when Bill.FromId in (zc_UnitId_StoreMaterialBasis(), zc_UnitId_StorePF(), zc_UnitId_StoreSalePF())
                             then 30201 -- Мясное сырье
                        when Bill.FromId in (zc_UnitId_StoreReturn(),zc_UnitId_StoreReturnBrak(),zc_UnitId_StoreReturnUtil())
                             then 30301 -- Переработка
                        when GoodsProperty.InfoMoneyCode in (20700) -- Прочие товары
                             then 30502 -- Прочие товары
                        else 30501 -- Прочие доходы
                   end as InfoMoneyCode
            from dba.Bill
                 left outer join dba.isUnit AS isUnitFrom on isUnitFrom.UnitId = Bill.FromId
                 left outer join dba.isUnit AS isUnitTo on isUnitTo.UnitId = Bill.ToId
                 left outer join dba.Unit AS UnitTo on UnitTo.Id = Bill.ToId
                 left outer join dba.Unit AS UnitFrom on UnitFrom.Id = Bill.FromId
                 join dba.BillItems on BillItems.BillId = Bill.Id and BillItems.OperCount<>0
                 left outer join dba.GoodsProperty on GoodsProperty.Id = BillItems.GoodsPropertyId
            where Bill.BillDate between  @inStartDate and @inEndDate
              and Bill.BillKind in (zc_bkSaleToClient(), zc_bkSendUnitToUnit())
              and isUnitFrom.UnitId is not null
              and isUnitTo.UnitId is null
              and (isnull (UnitTo.PersonalId_Postgres, 0) = 0 OR Bill.FromId = zc_UnitId_StoreSale())
              and isnull (UnitTo.pgUnitId, 0) = 0
              and Bill.MoneyKindId = zc_mkNal()
            group by Bill.FromId,Bill.ToId, GoodsProperty.InfoMoneyCode
           union all
            select Bill.FromId as ClientId
                  ,case when Bill.ToId in (zc_UnitId_StoreSale(),zc_UnitId_StoreReturn(),zc_UnitId_StoreReturnBrak(),zc_UnitId_StoreReturnUtil())
                             then 30101 -- Готовая продукция
                        when Bill.ToId in (zc_UnitId_StoreMaterialBasis(), zc_UnitId_StorePF(), zc_UnitId_StoreSalePF())
                             then 30201 -- Мясное сырье
                        -- when Bill.ToId in (zc_UnitId_StoreReturn(),zc_UnitId_StoreReturnBrak(),zc_UnitId_StoreReturnUtil())
                        --      then 30301 -- Переработка
                        when GoodsProperty.InfoMoneyCode in (20700) -- Прочие товары
                             then 30502 -- Прочие товары
                        else 30501 -- Прочие доходы
                   end as InfoMoneyCode
            from dba.Bill
                 left outer join dba.isUnit AS isUnitFrom on isUnitFrom.UnitId = Bill.FromId
                 left outer join dba.isUnit AS isUnitTo on isUnitTo.UnitId = Bill.ToId
                 left outer join dba.Unit AS UnitTo on UnitTo.Id = Bill.ToId
                 left outer join dba.Unit AS UnitFrom on UnitFrom.Id = Bill.FromId
                 join dba.BillItems on BillItems.BillId = Bill.Id and BillItems.OperCount<>0
                 left outer join dba.GoodsProperty on GoodsProperty.Id = BillItems.GoodsPropertyId
            where Bill.BillDate between  @inStartDate and @inEndDate
              and Bill.BillKind in (zc_bkReturnToUnit(), zc_bkSendUnitToUnit())
              and isUnitFrom.UnitId is null
              and isUnitTo.UnitId is not null
              and (isnull (UnitFrom.PersonalId_Postgres, 0) = 0 OR Bill.ToId in (zc_UnitId_StoreSale(), zc_UnitId_StoreReturn(),zc_UnitId_StoreReturnBrak(),zc_UnitId_StoreReturnUtil()))
              and isnull (UnitFrom.pgUnitId, 0) = 0
              and Bill.MoneyKindId = zc_mkNal()
            group by Bill.FromId,Bill.ToId, GoodsProperty.InfoMoneyCode
           )as tmpBill
            group by ClientId, InfoMoneyCode
           )as tmpBill

                left outer join dba.Unit on Unit.Id = tmpBill.ClientId
                left outer join dba.ClientInformation as Information1 on Information1.ClientID = Unit.InformationFromUnitID
                                                                      and Information1.OKPO <> ''
                left outer join dba.ClientInformation as Information2 on Information2.ClientID = Unit.Id
                left outer join dba._pgInfoMoney on _pgInfoMoney.ObjectCode = tmpBill.InfoMoneyCode
                left outer join dba.ClientSumm on ClientSumm.ClientId = isnull(zf_ChangeIntToNull(Unit.DolgByUnitID),Unit.Id)

           where trim(OKPO)<>''
        -- and zf_isOKPO_Virtual_PG(OKPO) = zc_rvYes()'
        -- and isnull(Unit.Id3_Postgres,0)=0' // !!!только новые
           order by ObjectName, tmpBill.InfoMoneyCode;

end
go
//
-- call dba._pgSelect_Partner_SaleNal ('2014-05-31', '2014-05-31', 1) 
 select * from dba._pgSelect_Partner_SaleNal ('2014-05-31', '2014-05-31', 1) as a
-- commit
