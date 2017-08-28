update dba.DiscountTaxItems set Id_Postgres = null ;
update dba.DiscountMovement set SaleId_Postgres = null , ReturnInId_Postgres = null  ;
update dba.DiscountMovementItem_byBarCode set Id_Postgres = null where Id_Postgres is not null;
update dba.DiscountMovementItemReturn_byBarCode set Id_Postgres = null where Id_Postgres is not null;


create table dba._pg_del (Name TVarCharMedium, Id_Postgres integer);


create trigger "dba".BillItems_000afterDelete_PG after delete order 771 on "DBA".BillItems
referencing old as @OldValue
for each row 
begin
   //
   //
   if @OldValue.Id_Postgres <> 0
   insert into _pg_del (Name , Id_Postgres)
    select 'BillItems', @OldValue.Id_Postgres
   end if
   ;
   //
   if @OldValue.ReturnOutId_Postgres <> 0
   insert into _pg_del (Name , Id_Postgres)
    select 'BillItems', @OldValue.ReturnOutId_Postgres
   end if
   ;
   //
   if @OldValue.SendId_Postgres <> 0
   insert into _pg_del (Name , Id_Postgres)
    select 'BillItems', @OldValue.SendId_Postgres
   end if
   ;
   //
   if @OldValue.LossId_Postgres <> 0
   insert into _pg_del (Name , Id_Postgres)
    select 'BillItems', @OldValue.LossId_Postgres
   end if
   ;
  //
end

create trigger "dba".BillItemsIncome_000afterDelete_PG after delete order 771 on "DBA".BillItemsIncome
referencing old as @OldValue
for each row 
begin
   //
   //
   if @OldValue.Id_Postgres <> 0
   insert into _pg_del (Name , Id_Postgres)
    select 'BillItemsIncome', @OldValue.Id_Postgres
   end if
   ;
  //
end
