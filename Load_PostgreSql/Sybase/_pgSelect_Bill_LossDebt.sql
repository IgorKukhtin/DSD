-- Int - LossDebt
alter PROCEDURE "DBA"."_pgSelect_Bill_LossDebt" (in @inEndDate date)
result (ObjectId Integer, MovementId_pg Integer, isSale smallint, Summa  TSumm, ClientId_pg Integer, ClientName TVarCharMedium, OKPO TVarCharMedium, minId Integer, maxId Integer)
begin
   //
   declare @MovementId_Income Integer;
   declare @MovementId_Sale Integer;
   //
  //
  declare local temporary table _tmpResult(
       UnitId Integer
      ,Summa TSumm
      ,isSale smallint
  ) on commit preserve rows;
   //
   //
/*           , case when fCheckUnitClientParentID (3504, Unit.ID) = zc_rvYes() -- œŒ ”œ¿“≈À»-¬—≈
                    or fCheckUnitClientParentID (4219, Unit.ID) = zc_rvYes() -- «¿¬»—ÿ»≈ ƒŒÀ√» ‘2

           , case when fCheckUnitClientParentID ( 152, Unit.ID) = zc_rvYes() -- œÓÒÚ‡‚˘ËÍË-¬—≈
                    or fCheckUnitClientParentID (9606, Unit.ID) = zc_rvYes() -- 
*/
   //
   -- œŒ ”œ¿“≈À»-¬—≈
   call dba.pCalculateReportClientSumm (@UserID= -1, @UnitID = 3504, @FromDate = @inEndDate + 1, @EndDate = zc_DateEnd(), @MoneyKindID = zc_mkNal(), @UnitIDIsGroup = zc_rvYes(), @isMoneyKind = zc_rvYes(), @beforeDelete = zc_rvYes(), @afterDelete = zc_rvNo());
   insert into _tmpResult (UnitId       ,Summa       ,isSale)
       select UnitId
            , SummClientEnd -- * zf_CalcClientSummSign (ClientSumm.IsSupplier)
            - (SaleToUnit-DiscountToUnit)
            + (SaleFromUnit-DiscountFromUnit)
            + (InMoney+InReturn)
            + IncomeFromUnit
          , zc_rvYes() as isSale
       from dba.tmpReportUnitSumm , dba.ClientSumm
       where tmpReportUnitSumm.UserID = -1 and tmpReportUnitSumm.ReportKind=zc_rkReportClientSumm()
         -- and ClientSumm.IsSupplier = zc_rvYes()
         and ClientSumm.ClientId = tmpReportUnitSumm.UnitId;
   --
   -- «¿¬»—ÿ»≈ ƒŒÀ√» ‘2
   call dba.pCalculateReportClientSumm (@UserID= -1, @UnitID = 4219, @FromDate = @inEndDate + 1, @EndDate = zc_DateEnd(), @MoneyKindID = zc_mkNal(), @UnitIDIsGroup = zc_rvYes(), @isMoneyKind = zc_rvYes(), @beforeDelete = zc_rvYes(), @afterDelete = zc_rvNo());
   insert into _tmpResult (UnitId       ,Summa       ,isSale)
       select UnitId
            , SummClientEnd -- * zf_CalcClientSummSign (ClientSumm.IsSupplier)
            - (SaleToUnit-DiscountToUnit)
            + (SaleFromUnit-DiscountFromUnit)
            + (InMoney+InReturn)
            + IncomeFromUnit
          , zc_rvYes() as isSale
       from dba.tmpReportUnitSumm , dba.ClientSumm
       where tmpReportUnitSumm.UserID = -1 and tmpReportUnitSumm.ReportKind=zc_rkReportClientSumm()
         -- and ClientSumm.IsSupplier = zc_rvYes()
         and ClientSumm.ClientId = tmpReportUnitSumm.UnitId;
   //
   //
   -- œÓÒÚ‡‚˘ËÍË-¬—≈
   call dba.pCalculateReportClientSumm (@UserID= -1, @UnitID = 152, @FromDate = @inEndDate + 1, @EndDate = zc_DateEnd(), @MoneyKindID = zc_mkNal(), @UnitIDIsGroup = zc_rvYes(), @isMoneyKind = zc_rvYes(), @beforeDelete = zc_rvYes(), @afterDelete = zc_rvNo());
   insert into _tmpResult (UnitId       ,Summa       ,isSale)
       select UnitId
            , SummClientEnd -- * zf_CalcClientSummSign (ClientSumm.IsSupplier)
            - (SaleToUnit-DiscountToUnit)
            + (SaleFromUnit-DiscountFromUnit)
            + (InMoney+InReturn)
            + IncomeFromUnit
          , zc_rvNo() as isSale
       from dba.tmpReportUnitSumm , dba.ClientSumm
       where tmpReportUnitSumm.UserID = -1 and tmpReportUnitSumm.ReportKind=zc_rkReportClientSumm()
         -- and ClientSumm.IsSupplier = zc_rvYes()
         and ClientSumm.ClientId = tmpReportUnitSumm.UnitId;
   --
   -- œŒ—“¿¬Ÿ» » œ¿¬»À‹ŒÕ€
   call dba.pCalculateReportClientSumm (@UserID= -1, @UnitID = 9606, @FromDate = @inEndDate + 1, @EndDate = zc_DateEnd(), @MoneyKindID = zc_mkNal(), @UnitIDIsGroup = zc_rvYes(), @isMoneyKind = zc_rvYes(), @beforeDelete = zc_rvYes(), @afterDelete = zc_rvNo());
   insert into _tmpResult (UnitId       ,Summa       ,isSale)
       select UnitId
            , SummClientEnd -- * zf_CalcClientSummSign (ClientSumm.IsSupplier)
            - (SaleToUnit-DiscountToUnit)
            + (SaleFromUnit-DiscountFromUnit)
            + (InMoney+InReturn)
            + IncomeFromUnit
          , zc_rvNo() as isSale
       from dba.tmpReportUnitSumm , dba.ClientSumm
       where tmpReportUnitSumm.UserID = -1 and tmpReportUnitSumm.ReportKind=zc_rkReportClientSumm()
         -- and ClientSumm.IsSupplier = zc_rvYes()
         and ClientSumm.ClientId = tmpReportUnitSumm.UnitId;
   //
   //
   select _tmpResult.UnitId as ObjectId
        , @MovementId_Income AS MovementId_pg
        , _tmpResult.isSale
        , _tmpResult.Summa
        , _tmpResult.ClientId_pg
        , Unit.UnitName as ClientName
        , _tmpResult.OKPO
        , _tmpResult.minId
        , _tmpResult.maxId
   from (select isnull (Unit_dolg.Id, Unit.Id) as UnitId
              , _tmpResult.isSale
              , sum (_tmpResult.Summa) as Summa
              , min (Unit.Id) as minId
              , max (Unit.Id) as maxId
        , max (isnull (_pgPartner.PartnerId_pg, isnull (Unit.Id3_Postgres, 0))) as ClientId_pg
        , max (isnull (Information1.OKPO, isnull (Information2.OKPO, ''))) AS OKPO
         from _tmpResult
              left outer join dba.Unit on Unit.Id = _tmpResult.UnitId
              left outer join dba.Unit as Unit_dolg on Unit_dolg.Id = Unit.DolgByUnitID
                                                   -- and 1=0
        left outer join (select max (isnull(_pgPartner.PartnerId_pg,0)) as PartnerId_pg, OKPO, UnitId, Main from dba._pgPartner where trim(OKPO) <> '' and _pgPartner.PartnerId_pg <> 0 and UnitId <>0 and Main <> 0 group by OKPO, UnitId, Main
                        ) as _pgPartner on _pgPartner.UnitId = _tmpResult.UnitId
        left outer join dba.ClientInformation as Information1 on Information1.ClientID = Unit.InformationFromUnitID
                                                             and Information1.OKPO <> ''
        left outer join dba.ClientInformation as Information2 on Information2.ClientID = Unit.Id

         group by isnull (Unit_dolg.Id, Unit.Id), _tmpResult.isSale
         having sum (_tmpResult.Summa) <> 0
        ) as _tmpResult
        left outer join dba.Unit on Unit.Id = _tmpResult.UnitId
   ;

end
go
//
-- select sum (summa) from dba._pgSelect_Bill_LossDebt ('2014-05-31') as a where isSale = zc_rvYes()
 select * from dba._pgSelect_Bill_LossDebt ('2014-05-31') as a where ClientId_pg = 0 and isSale = zc_rvYes() order by ClientName
-- select * from dba._pgSelect_Bill_LossDebt ('2014-05-31') as a where isSale = zc_rvYes() order by ClientName
-- call dba._pgSelect_Bill_LossDebt ('2014-05-31') 