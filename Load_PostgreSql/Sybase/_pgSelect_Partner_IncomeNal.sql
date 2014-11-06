-- Int - Partner_IncomeNal
alter PROCEDURE "DBA"."_pgSelect_Partner_IncomeNal" (in @inStartDate date, in @inEndDate date, in @inParentId_PG_in integer)
result (ObjectId Integer, ObjectCode Integer, ObjectName TVarCharLong, ParentId_Postgres Integer
      , Address TVarCharLongLong, InfoMoneyCode integer, InfoMoneyId_PG integer, OKPO TVarCharLong, isOKPO_Virtual smallint, DayCount_Real integer, DayCount_Bank integer, Id_Postgres integer)
begin
   //
            select Unit.Id as ObjectId
                 , Unit.UnitCode as ObjectCode
                 , trim(Unit.UnitName) as ObjectName
                 , @inParentId_PG_in  as ParentId_Postgres -- 02-œÓÒÚ‡‚˘ËÍË
                 , Information2.AddressFirm as Address
                 , tmpBill.InfoMoneyCode
                 , _pgInfoMoney.Id3_Postgres AS InfoMoneyId_PG
                 , isnull (Information1.OKPO, isnull (Information2.OKPO, '')) AS OKPO
                 , case when Unit.PersonalId_Postgres<>0 then zc_rvYes() else zf_isOKPO_Virtual_PG(OKPO) end as isOKPO_Virtual
                 , ClientSumm.DayCount_Real
                 , ClientSumm.DayCount_Bank
                 , isnull(Unit.Id3_Postgres,0) as Id_Postgres
            from 
           (select  ClientId
                  , max (InfoMoneyCode) as InfoMoneyCode
            from
            -- !!! remains
           (select ObjectId as ClientId, InfoMoneyCode
            from _pgSelect_Bill_LossDebt (@inStartDate - 1)
            where ClientId_pg = 0 and trim (OKPO) <> '' and isSale=zc_rvNo() and 1 =0 
           union all
            -- !!! Income
            select Bill.FromId as ClientId
                 , max (isnull(GoodsProperty.InfoMoneyCode,0))as InfoMoneyCode
            from dba.Bill
                 left outer join dba.Unit as UnitFrom on UnitFrom.Id = Bill.FromId
                 inner join dba.BillItems on BillItems.BillId = Bill.Id and BillItems.OperCount<>0 and BillItems.OperPrice<>0
                 left outer join dba.GoodsProperty on GoodsProperty.Id = BillItems.GoodsPropertyId
            where Bill.BillDate between  @inStartDate and @inEndDate
              and Bill.BillKind=zc_bkIncomeToUnit()
              and Bill.ToId<>4927 -- — À¿ƒ œ≈–≈œ¿ 
              and Bill.FromId not in (3830, 3304)  --   –Œ“ŒÕ ŒŒŒ (ı‡ÌÂÌËÂ) +  –Œ“ŒÕ ŒŒŒ
              and Bill.ToId not in (3830, 3304) --  –Œ“ŒÕ ŒŒŒ (ı‡ÌÂÌËÂ) +  –Œ“ŒÕ ŒŒŒ
              -- and Bill.FromId <> 4928 -- ‘Œ««»-œ≈–≈œ¿  œ–Œƒ” ÷»»
              and UnitFrom.PersonalId_Postgres is null
              and Bill.MoneyKindId = zc_mkNal()
           group by Bill.FromId
           union all
            -- !!! ReturnOut
            select Bill.ToId as ClientId
                 , max (isnull(GoodsProperty.InfoMoneyCode,0))as InfoMoneyCode
            from dba.Bill
                 left outer join dba.Unit AS UnitTo on UnitTo.Id = Bill.ToId
                 inner join dba.BillItems on BillItems.BillId = Bill.Id and BillItems.OperCount<>0 -- and BillItems.OperPrice<>0
                 left outer join dba.GoodsProperty on GoodsProperty.Id = BillItems.GoodsPropertyId
            where Bill.BillDate between  @inStartDate and @inEndDate
              and Bill.BillKind=zc_bkReturnToClient()
              and Bill.FromId not in (3830, 3304)  --   –Œ“ŒÕ ŒŒŒ (ı‡ÌÂÌËÂ) +  –Œ“ŒÕ ŒŒŒ
              and Bill.ToId not in (3830, 3304) --  –Œ“ŒÕ ŒŒŒ (ı‡ÌÂÌËÂ) +  –Œ“ŒÕ ŒŒŒ
              and Bill.MoneyKindId = zc_mkNal()
            group by Bill.ToId
           )as tmpBill
            group by ClientId
           )as tmpBill

                left outer join dba.Unit on Unit.Id = tmpBill.ClientId
                left outer join dba.ClientInformation as Information1 on Information1.ClientID = Unit.InformationFromUnitID
                                                                      and Information1.OKPO <> ''
                left outer join dba.ClientInformation as Information2 on Information2.ClientID = Unit.Id
                left outer join dba._pgInfoMoney on _pgInfoMoney.ObjectCode = tmpBill.InfoMoneyCode
                left outer join dba.ClientSumm on ClientSumm.ClientId = isnull(zf_ChangeIntToNull(Unit.DolgByUnitID),Unit.Id)

           where trim(OKPO)<>''
        -- and zf_isOKPO_Virtual_PG(OKPO) = zc_rvYes()'
        -- and isnull(Unit.Id3_Postgres,0)=0' // !!!ÚÓÎ¸ÍÓ ÌÓ‚˚Â
           order by ObjectName, tmpBill.InfoMoneyCode;

end
go
//
-- call dba._pgSelect_Partner_IncomeNal ('2014-05-31', '2014-05-31', 1) 
-- select * from dba._pgSelect_Partner_IncomeNal ('2014-05-31', '2014-05-31', 1) as a
-- commit
