-- InfoMoneyName
update Object set ValueData = 'сырье 1'  from Object_InfoMoney_View  where Object_InfoMoney_View.InfoMoneyId = Object.Id  and InfoMoneyCode = 10101; -- Живой вес
update Object set ValueData = 'сырье 2'  from Object_InfoMoney_View  where Object_InfoMoney_View.InfoMoneyId = Object.Id  and InfoMoneyCode = 10102; -- Свинина
update Object set ValueData = 'сырье 3'  from Object_InfoMoney_View  where Object_InfoMoney_View.InfoMoneyId = Object.Id  and InfoMoneyCode = 10103; -- Говядина
update Object set ValueData = 'сырье 4'  from Object_InfoMoney_View  where Object_InfoMoney_View.InfoMoneyId = Object.Id  and InfoMoneyCode = 10104; -- Курица

-- InfoMoneyName
update Object set ValueData = 'Доп. сырье *1*'  from Object_InfoMoney_View  where Object_InfoMoney_View.InfoMoneyId = Object.Id  and InfoMoneyCode = 10105; -- Прочее мясное сырье
update Object set ValueData = 'Доп. сырье *2*'  from Object_InfoMoney_View  where Object_InfoMoney_View.InfoMoneyId = Object.Id  and InfoMoneyCode = 10106; -- Сыр

-- InfoMoneyName
update Object set ValueData = 'Составляюшие'  from Object_InfoMoney_View  where Object_InfoMoney_View.InfoMoneyId = Object.Id  and InfoMoneyCode = 10201; -- Специи
update Object set ValueData = 'Компоненты'    from Object_InfoMoney_View  where Object_InfoMoney_View.InfoMoneyId = Object.Id  and InfoMoneyCode = 10202; -- Оболочка

-- InfoMoneyName
update Object set ValueData = 'Бизнес основной'  from Object_InfoMoney_View  where Object_InfoMoney_View.InfoMoneyId = Object.Id  and InfoMoneyCode = 20801; -- Алан
update Object set ValueData = 'Бизнес другой 1'  from Object_InfoMoney_View  where Object_InfoMoney_View.InfoMoneyId = Object.Id  and InfoMoneyCode = 20901; -- Ирна
update Object set ValueData = 'Бизнес другой 2'  from Object_InfoMoney_View  where Object_InfoMoney_View.InfoMoneyId = Object.Id  and InfoMoneyCode = 21001; -- Чапли 
update Object set ValueData = 'Бизнес другой 3'  from Object_InfoMoney_View  where Object_InfoMoney_View.InfoMoneyId = Object.Id  and InfoMoneyCode = 21101; -- Дворкин
update Object set ValueData = 'Бизнес основной'  from Object_InfoMoney_View  where Object_InfoMoney_View.InfoMoneyDestinationId = Object.Id  and InfoMoneyCode = 20801; -- Алан
update Object set ValueData = 'Бизнес другой 1'  from Object_InfoMoney_View  where Object_InfoMoney_View.InfoMoneyDestinationId = Object.Id  and InfoMoneyCode = 20901; -- Ирна
update Object set ValueData = 'Бизнес другой 2'  from Object_InfoMoney_View  where Object_InfoMoney_View.InfoMoneyDestinationId = Object.Id  and InfoMoneyCode = 21001; -- Чапли 
update Object set ValueData = 'Бизнес другой 3'  from Object_InfoMoney_View  where Object_InfoMoney_View.InfoMoneyDestinationId = Object.Id  and InfoMoneyCode = 21101; -- Дворкин

-- InfoMoneyName
update Object set ValueData = 'Доставка основного сырья'  from Object_InfoMoney_View  where Object_InfoMoney_View.InfoMoneyId = Object.Id  and InfoMoneyCode = 21406; -- доставка Мясного сырья
-- InfoMoneyName
update Object set ValueData = 'Бонусы за реализ. сырья'  from Object_InfoMoney_View  where Object_InfoMoney_View.InfoMoneyId = Object.Id  and InfoMoneyCode = 21502; -- Бонусы за мясное сырье
update Object set ValueData = 'маркетинг Бизнес другой 3'  from Object_InfoMoney_View  where Object_InfoMoney_View.InfoMoneyId = Object.Id  and InfoMoneyCode = 21511; -- маркетинг Хлеб

-- InfoMoneyName
update Object set ValueData = 'ГП бизнес другой 2'  from Object_InfoMoney_View  where Object_InfoMoney_View.InfoMoneyId = Object.Id  and InfoMoneyCode = 30102; -- Тушенка
update Object set ValueData = 'ГП бизнес другой 3'  from Object_InfoMoney_View  where Object_InfoMoney_View.InfoMoneyId = Object.Id  and InfoMoneyCode = 30103; -- Хлеб
update Object set ValueData = 'Сырье'  from Object_InfoMoney_View  where Object_InfoMoney_View.InfoMoneyId = Object.Id  and InfoMoneyCode = 30201; -- Мясное сырье
update Object set ValueData = 'Сырье'  from Object_InfoMoney_View  where Object_InfoMoney_View.InfoMoneyDestinationId = Object.Id  and InfoMoneyCode = 30201; -- Мясное сырье

-- InfoMoneyName
update Object set ValueData = 'Транзит'  from Object_InfoMoney_View  where Object_InfoMoney_View.InfoMoneyId = Object.Id  and InfoMoneyCode = 40701; -- Лиол
update Object set ValueData = 'Транзит'  from Object_InfoMoney_View  where Object_InfoMoney_View.InfoMoneyDestinationId = Object.Id  and InfoMoneyCode = 40701; -- Лиол
-- InfoMoneyName
update Object set ValueData = 'Цех сырья'  from Object_InfoMoney_View  where Object_InfoMoney_View.InfoMoneyId = Object.Id  and InfoMoneyCode = 70402; -- Обвалка

-- InfoMoneyName
update Object set ValueData = 'А'  from Object_InfoMoney_View  where Object_InfoMoney_View.InfoMoneyId = Object.Id  and InfoMoneyCode = 80301; -- 
update Object set ValueData = 'Б'  from Object_InfoMoney_View  where Object_InfoMoney_View.InfoMoneyId = Object.Id  and InfoMoneyCode = 80302; -- 
update Object set ValueData = 'В'  from Object_InfoMoney_View  where Object_InfoMoney_View.InfoMoneyId = Object.Id  and InfoMoneyCode = 80303; -- 
update Object set ValueData = 'Г'  from Object_InfoMoney_View  where Object_InfoMoney_View.InfoMoneyId = Object.Id  and InfoMoneyCode = 80304; -- 

-- InfoMoneyDestinationName = Основное сырье - Мясное сырье
-- update Object set ValueData = Object_InfoMoney_View.InfoMoneyDestinationName || ' ' || Object.Id :: TVarChar
 update Object set ValueData = Object_InfoMoney_View.InfoMoneyName || ' ' || Object.Id :: TVarChar
from ObjectLink
     join Object_InfoMoney_View on Object_InfoMoney_View.InfoMoneyId = ObjectLink.ChildObjectId
                               and InfoMoneyCode between 10101 and 10106
where ObjectLink.DescId = zc_ObjectLink_Goods_InfoMoney() 
   and Object.Id = ObjectLink.ObjectId;

-- InfoMoneyDestinationName = Основное сырье - Прочее сырье
 update Object set ValueData = Object_InfoMoney_View.InfoMoneyName || ' ' || Object.Id :: TVarChar
from ObjectLink
     join Object_InfoMoney_View on Object_InfoMoney_View.InfoMoneyId = ObjectLink.ChildObjectId
                               and InfoMoneyCode between 10201 and 10204
where ObjectLink.DescId = zc_ObjectLink_Goods_InfoMoney() 
   and Object.Id = ObjectLink.ObjectId;

-- InfoMoneyDestinationName = Прочее сырье
 update Object set ValueData = Object_InfoMoney_View.InfoMoneyName || ' ' || Object.Id :: TVarChar
from ObjectLink
     join Object_InfoMoney_View on Object_InfoMoney_View.InfoMoneyId = ObjectLink.ChildObjectId
                               and InfoMoneyCode between 30101 and 10204
where ObjectLink.DescId = zc_ObjectLink_Goods_InfoMoney() 
   and Object.Id = ObjectLink.ObjectId;




