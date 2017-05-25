#Использовать asserts
#Использовать logos
#Использовать 1commands
// #Использовать "./Классы"
// #Использовать "./Модули"
#Использовать "."

Перем Лог;

Перем мВыводКоманды;
Перем ИмяФайлаИнформации;
Перем РабочийКаталог;
Перем ПутьКГит;
Перем СистемнаяИнформация;
Перем ЭтоWindows;
Перем НастройкиКоманд;

/////////////////////////////////////////////////////////////////////////
// Программный интерфейс

/////////////////////////////////////////////////////////////////////////
// Процедуры-обертки над git

// Выполняет инициализиацию репозитория в рабочем каталоге
// git init
//
Процедура Инициализировать() Экспорт
    
    ПараметрыЗапуска = Новый Массив;
    ПараметрыЗапуска.Добавить("init");
    
    ВыполнитьКоманду(ПараметрыЗапуска);
    
КонецПроцедуры

// Получает состояние репозитория
// git status
//
//  Возвращаемое значение:
//   Строка   - Вывод команды
//
Функция Статус() Экспорт
    
    ПараметрыЗапуска = Новый Массив;
    ПараметрыЗапуска.Добавить("status");
    
    ВыполнитьКоманду(ПараметрыЗапуска);
    
    Возврат ПолучитьВыводКоманды();
    
КонецФункции

// Добавляет файл в индекс git
// git add
//
// Параметры:
//   ПутьКДобавляемомуФайлу - Строка - Путь к файлу на диске
//
Процедура ДобавитьФайлВИндекс(Знач ПутьКДобавляемомуФайлу) Экспорт
    
    ПараметрыЗапуска = Новый Массив;
    ПараметрыЗапуска.Добавить("add");
    ПараметрыЗапуска.Добавить(ПутьКДобавляемомуФайлу);
    
    ВыполнитьКоманду(ПараметрыЗапуска);

КонецПроцедуры

// Зафиксировать проиндексированные изменения в истории git
// git commit
//
// Параметры:
//   ТекстСообщения - Строка - Текст сообщения коммита (-m ТекстСообщения)
//   ПроиндексироватьОтслеживаемыеФайлы - Булево - Автоматически добавить
//     в индекс файлы, уже отслеживаемые git (-a)
//   ПутьКФайлуКоммита - Строка - путь к файлу с текстом комментария (-F ПутьКФайлуСтекстомКоммита)
//   АвторКоммита - Строка - Автор комментария, передается в случае необходимости (--author=АвторКоммита)
//   ДатаАвтораКоммита - Дата - Дата комментария (--date=ДатаАвтораКоммита)
//   Коммитер - Строка - Коммитер комментария, передается в случае, если требуется
//   ДатаКоммита - Дата - Дата произведения коммита
//
Процедура Закоммитить(Знач ТекстСообщения = "", 
                        Знач ПроиндексироватьОтслеживаемыеФайлы = Ложь,
                        Знач ПутьКФайлуКоммита = "", 
                        Знач АвторКоммита = "", 
                        Знач ДатаАвтораКоммита = '00010101',
                        Знач Коммитер = "", 
                        Знач ДатаКоммита = '00010101') Экспорт

    НадоВосстановитьКоммитера = Ложь;
    НадоОчиститьУстановленныеПеременные = ложь;    

    ПараметрыЗапуска = Новый Массив;
    ПараметрыЗапуска.Добавить("commit");

    Если ПроиндексироватьОтслеживаемыеФайлы Тогда
        ПараметрыЗапуска.Добавить("-a");
    КонецЕсли;

    Если Не ПустаяСтрока(ПутьКФайлуКоммита) Тогда
        ПараметрыЗапуска.Добавить("-F");
        ПараметрыЗапуска.Добавить(ОбернутьВКавычки(ПутьКФайлуКоммита));
    Иначе 
        ПараметрыЗапуска.Добавить("-m");
        ПараметрыЗапуска.Добавить(ОбернутьВКавычки(ТекстСообщения));
    КонецЕсли;

    Если Не ПустаяСтрока(Коммитер) Тогда

        УстановитьКоммитера(Коммитер, НадоВосстановитьКоммитера);

    КонецЕсли;

    Если ЗначениеЗаполнено(ДатаКоммита) Тогда
        НадоОчиститьУстановленныеПеременные = Истина;
        УстановитьДатуКоммита(ДатаКоммита);
    КонецЕсли;

    Если Не ПустаяСтрока(АвторКоммита) Тогда
        ПараметрыЗапуска.Добавить("--author="+ ОбернутьВКавычки(АвторКоммита));
    КонецЕсли;

    Если ЗначениеЗаполнено(ДатаАвтораКоммита) Тогда
        ПараметрыЗапуска.Добавить("--date="+ ОбернутьВКавычки(ДатаАвтораКоммита));
    КонецЕсли;

	КомандаВыполненаУспешно = Истина;
	Попытка
        ВыполнитьКоманду(ПараметрыЗапуска);
    Исключение
		КомандаВыполненаУспешно = Ложь;       
    КонецПопытки;
	ВыводКоманды = ПолучитьВыводКоманды();
    
	Если НадоОчиститьУстановленныеПеременные Тогда 
		ОчиститьУстановленныеПеременныеГит();
	КонецЕсли;
	Если НадоВосстановитьКоммитера Тогда
		ВосстановитьКоммитера();
	КонецЕсли;

	Если НЕ КомандаВыполненаУспешно Тогда
		ВызватьИсключение ВыводКоманды;
	КонецЕсли;

КонецПроцедуры

// Вывести историю репозитория
// git log
//
// Параметры:
//   Графически - Булево - Вывести историю в виде графа (--graph)
//
Процедура ВывестиИсторию(Графически = Ложь) Экспорт
    
    ПараметрыЗапуска = Новый Массив;
    ПараметрыЗапуска.Добавить("log");
    
    Если Графически Тогда
        ПараметрыЗапуска.Добавить("--graph");
    КонецЕсли;
    
    ВыполнитьКоманду(ПараметрыЗапуска);
    
КонецПроцедуры

// Получить изменения из удаленного репозитория
// git pull
//
// Параметры:
//   ИмяРепозитория - Строка - Имя репозитория, из которого необходимо
// 		получить изменения
//   ИмяВетки - Строка - Имя ветки, из которой необходимо получить изменения
//
Процедура Получить(Знач ИмяРепозитория = "", Знач ИмяВетки = "") Экспорт
    
    ПараметрыЗапуска = Новый Массив;
    ПараметрыЗапуска.Добавить("pull");
    
    Если ЗначениеЗаполнено(ИмяРепозитория) Тогда
        ПараметрыЗапуска.Добавить(ИмяРепозитория);
    КонецЕсли;
    
    Если ЗначениеЗаполнено(ИмяВетки) Тогда
        ПараметрыЗапуска.Добавить(ИмяВетки);
    КонецЕсли;
    
    ВыполнитьКоманду(ПараметрыЗапуска);
    
КонецПроцедуры

// Отправить изменения в удаленный репозиторий
// git push
//
// Параметры:
//   ИмяРепозитория - Строка - Имя репозитория, в который необходимо
// 		отправить изменения
//   ИмяВетки - Строка - Имя ветки, в который необходимо отправить изменения
//   ПерезаписатьИсторию - Булево - Флаг отправки с перезаписью истории (--force)
//
Процедура Отправить(Знач ИмяРепозитория = "", Знач ИмяВетки = "", Знач ПерезаписатьИсторию = Ложь) Экспорт

    КомандаГит = Новый КомандаГитРепозитория;
    КомандаГит.УстановитьКоманду("push");
    КомандаГит.УстановитьКонтекст(ЭтотОбъект);
    
    НастройкаКоманды = НастройкиКоманд.Получить("Отправить");

    Если НастройкаКоманды = Неопределено Тогда
        НастройкаКоманды = Новый НастройкаКомандыОтправить;
    КонецЕсли;

    Если ПерезаписатьИсторию Тогда
        НастройкаКоманды.ПерезаписатьИсторию();
    КонецЕсли;
    
    Если ЗначениеЗаполнено(ИмяРепозитория) Тогда
        НастройкаКоманды.УстановитьURLРепозиторияОтправки(ИмяРепозитория);
    КонецЕсли;
    
    Если ЗначениеЗаполнено(ИмяВетки) Тогда
        НастройкаКоманды.УстановитьЗаголовкиОтправки(ИмяВетки);
    КонецЕсли;
    
    КомандаГит.УстановитьНастройкуКоманды(НастройкаКоманды);
    КомандаГит.ВыполнитьКоманду();
    
КонецПроцедуры

// Установить настройки отправки изменений.
// Позволяет произвести тонкую настройку необходимых флагов команды отправки изменений
//
// Параметры:
//   НастройкаКомандыОтправить - НастройкаКомандыОтправить - инстанс класса НастройкаКомандыОтправить с необходимыми
//                                                          настройками
//
Процедура УстановитьНастройкуКомандыОтправить(НастройкаКомандыОтправить) Экспорт
    
	УстановитьНастройкуКоманды("Отправить", НастройкаКомандыОтправить);

КонецПроцедуры

// Клонировать удаленный репозиторий
// git clone
//
// Параметры:
//   ПутьУдаленномуРепозиторию - Строка - Путь к удаленному репозиторию
//   КаталогКлонирования - Строка - Каталог, в который необходимо выполнить
//		клонирование
//
Процедура КлонироватьРепозиторий(Знач ПутьУдаленномуРепозиторию, Знач КаталогКлонирования = "") Экспорт

    // TODO: Потенциально bad-design. По-хорошему это не относится к объекту
    // ГитРепозиторий, это что-то вроде ГитМенеджер.
    
    КомандаГит = Новый КомандаГитРепозитория;
    КомандаГит.УстановитьКоманду("clone");
    КомандаГит.УстановитьКонтекст(ЭтотОбъект);
    
    НастройкаКоманды = НастройкиКоманд.Получить("Клонировать");

    Если НастройкаКоманды = Неопределено Тогда
        НастройкаКоманды = Новый НастройкаКомандыКлонировать;
    КонецЕсли;
 
    Если ЗначениеЗаполнено(ПутьУдаленномуРепозиторию) Тогда
        НастройкаКоманды.УстановитьURLРепозиторияКлонирования(ПутьУдаленномуРепозиторию);
    КонецЕсли;
    
    Если ЗначениеЗаполнено(КаталогКлонирования) Тогда
        НастройкаКоманды.УстановитьКаталогКлонирования(ОбернутьВКавычки(КаталогКлонирования));
    КонецЕсли;
    
    КомандаГит.УстановитьНастройкуКоманды(НастройкаКоманды);
    КомандаГит.ВыполнитьКоманду();
    
КонецПроцедуры

// Установить настройки клонирования репозитория.
// Позволяет произвести тонкую настройку необходимых флагов команды клонирования репозитория
//
// Параметры:
//   НастройкаКомандыКлонировать - НастройкаКомандыКлонировать - инстанс класса НастройкаКомандыКлонировать с необходимыми
//                                                          настройками
//
Процедура УстановитьНастройкуКомандыКлонировать(НастройкаКомандыКлонировать) Экспорт
    
	УстановитьНастройкуКоманды("Клонировать", НастройкаКомандыКлонировать);

КонецПроцедуры

//////////////////////////////////////////////
// Работа с ветками

// Получить имя текущей ветки
//
//  Возвращаемое значение:
//   Строка   - Имя текущей ветки
//
Функция ПолучитьТекущуюВетку() Экспорт
    
    ПараметрыЗапуска = Новый Массив;
    ПараметрыЗапуска.Добавить("symbolic-ref");
    ПараметрыЗапуска.Добавить("--short");
    ПараметрыЗапуска.Добавить("HEAD");
    
    ВыполнитьКоманду(ПараметрыЗапуска);
    
    ВыводКоманды = ПолучитьВыводКоманды();
    
    Возврат ВыводКоманды;
    
КонецФункции

// Выполнить переход в ветку
// git checkout
//
// Параметры:
//   ИмяВетки - Строка - Имя ветки, в которую необходимо перейти
//   СоздатьНовую - Булево - Флаг необходимости создания новой ветки (-b)
//   Принудительно - Булево - Флаг необходимости принудительно перейти в ветку (-f)
//
// @unstable
//
Процедура ПерейтиВВетку(Знач ИмяВетки, Знач СоздатьНовую = Ложь, Знач Принудительно = Ложь) Экспорт
    
    ПараметрыЗапуска = Новый Массив;
    ПараметрыЗапуска.Добавить("checkout");
    
    Если СоздатьНовую Тогда
        ПараметрыЗапуска.Добавить("-b");
    КонецЕсли;

    Если Принудительно Тогда
        ПараметрыЗапуска.Добавить("-f");
    КонецЕсли;
    
    ПараметрыЗапуска.Добавить(ИмяВетки);
    
    ВыполнитьКоманду(ПараметрыЗапуска);
    
КонецПроцедуры

// Создать новую ветку без выполнения перехода в нее
// git branch
//
// Параметры:
//   ИмяВетки - Строка - Имя создаваемой ветки
//
Процедура СоздатьВетку(Знач ИмяВетки) Экспорт
    
    ПараметрыЗапуска = Новый Массив;
    ПараметрыЗапуска.Добавить("branch");    
    ПараметрыЗапуска.Добавить(ИмяВетки);
    
    ВыполнитьКоманду(ПараметрыЗапуска);
    
КонецПроцедуры

// Получить список веток
//
// Параметры:
//   ВключаяУдаленные - Булево - Включать информацию об удаленных ветках
//
//  Возвращаемое значение:
//   ТаблицаЗначений   - Таблица с информацией о текущих ветках.
//		Содержит колонки:
//			Текущая - Булево - Признак текущей ветки
//			Имя - Строка - Имя ветки
//
Функция ПолучитьСписокВеток(Знач ВключаяУдаленные = Ложь) Экспорт
    
    ПараметрыЗапуска = Новый Массив;
    ПараметрыЗапуска.Добавить("branch");    
    
    Если ВключаяУдаленные Тогда
        ПараметрыЗапуска.Добавить("-a");    
    КонецЕсли;
    
    ВыполнитьКоманду(ПараметрыЗапуска);
    
    ВыводКоманды = ПолучитьВыводКоманды();
    
    ТаблицаВеток = Новый ТаблицаЗначений();
    ТаблицаВеток.Колонки.Добавить("Текущая");
    ТаблицаВеток.Колонки.Добавить("Имя");
    
    ЧислоСтрок = СтрЧислоСтрок(ВыводКоманды);
    
    Для сч = 1 По ЧислоСтрок Цикл
        
        Ветка = ТаблицаВеток.Добавить();
        
        Строка = СокрЛП(СтрПолучитьСтроку(ВыводКоманды, сч));

        Ветка.Текущая = Лев(Строка, 1) = "*";
        
        Если Ветка.Текущая Тогда
            Строка = Прав(Строка, СтрДлина(Строка) - 2);
        КонецЕсли;

        Ветка.Имя = Строка;
        
    КонецЦикла;
    
    Возврат ТаблицаВеток;
    
    
КонецФункции

// Работа с ветками
//////////////////////////////////////////////

//////////////////////////////////////////////
// Работа с внешними репозиториями

// Добавить внешний репозиторий
// git remote add 
//
// Параметры:
//   ИмяРепозитория - Строка - Имя внешнего репозитория
//   АдресВнешнегоРепозитория - Строка - Путь к внешнему репозиторию
//
Процедура ДобавитьВнешнийРепозиторий(Знач ИмяРепозитория, Знач АдресВнешнегоРепозитория) Экспорт
    
    ПараметрыЗапуска = Новый Массив;
    ПараметрыЗапуска.Добавить("remote");
    ПараметрыЗапуска.Добавить("add");
    
    ПараметрыЗапуска.Добавить(ИмяРепозитория);
    ПараметрыЗапуска.Добавить(АдресВнешнегоРепозитория);
    
    ВыполнитьКоманду(ПараметрыЗапуска);
    
КонецПроцедуры

// Удалить внешний репозиторий
// git remote remove
//
// Параметры:
//   ИмяРепозитория - Строка - Имя внешнего репозитория
//
Процедура УдалитьВнешнийРепозиторий(Знач ИмяРепозитория) Экспорт
    
    ПараметрыЗапуска = Новый Массив;
    ПараметрыЗапуска.Добавить("remote");
    ПараметрыЗапуска.Добавить("remove");
    
    ПараметрыЗапуска.Добавить(ИмяРепозитория);
    
    ВыполнитьКоманду(ПараметрыЗапуска);
    
КонецПроцедуры

// Получить список внешних репозиториев
//
//  Возвращаемое значение:
//   ТаблицаЗначений   - Таблица с информацией о внешних репозиториях.
//		Содержит колонки:
//			Имя - Строка - Имя внешнего репозитория
//			Адрес - Строка - Путь к внешнему репозиторию
//			Режим - Строка - Режим работы с внешним репозиторием (push/fetch)
//
Функция ПолучитьСписокВнешнихРепозиториев() Экспорт
    
    ПараметрыЗапуска = Новый Массив;
    ПараметрыЗапуска.Добавить("remote");
    ПараметрыЗапуска.Добавить("-v");
    
    ВыполнитьКоманду(ПараметрыЗапуска);
    
    ВыводКоманды = ПолучитьВыводКоманды();
    
    ТаблицаВнешнихРепозиториев = Новый ТаблицаЗначений;
    ТаблицаВнешнихРепозиториев.Колонки.Добавить("Имя");
    ТаблицаВнешнихРепозиториев.Колонки.Добавить("Адрес");
    ТаблицаВнешнихРепозиториев.Колонки.Добавить("Режим");
    
    ЧислоСтрок = СтрЧислоСтрок(ВыводКоманды);
    
    Для сч = 1 По ЧислоСтрок Цикл
        
        ВнешнийРепозиторий = ТаблицаВнешнихРепозиториев.Добавить();
        
        Строка = СтрПолучитьСтроку(ВыводКоманды, сч);
        СимволТаб = СтрНайти(Строка, Символы.Таб);
        СимволПробел = СтрНайти(Строка, " ");
        
        ИмяВнешнегоРепозитория = Лев(Строка, СимволТаб - 1);
        АдресВнешнегоРепозитория = Сред(Строка, СимволТаб + 1, СимволПробел - СимволТаб - 1);
        РежимВнешнегоРепозитория = Прав(Строка, СтрДлина(Строка) - СимволПробел);
        РежимВнешнегоРепозитория = Сред(РежимВнешнегоРепозитория, 2, СтрДлина(РежимВнешнегоРепозитория) - 2);
        
        ВнешнийРепозиторий.Имя 		= СокрЛП(ИмяВнешнегоРепозитория);
        ВнешнийРепозиторий.Адрес 	= СокрЛП(АдресВнешнегоРепозитория);
        ВнешнийРепозиторий.Режим 	= СокрЛП(РежимВнешнегоРепозитория);
        
    КонецЦикла;
    
    Возврат ТаблицаВнешнихРепозиториев;
    
КонецФункции

// Работа с внешними репозиториями
//////////////////////////////////////////////

//////////////////////////////////////////////
// Работа с подмодулями

// Добавить новый подмодуль
// git submodule add
//
// Параметры:
//   АдресВнешнегоРепозитория - Строка - Путь к внешнему репозиторию
//   Местоположение - Строка - Каталог, в который необходимо поместить
//		указанный подмодуль
//   Ветка - Строка - Имя ветки внешнего репозитория для получения (-b Ветка)
//   ИмяПодмодуля - Строка - Имя, под которым подмодуль будет сохранен
//		в настройках (--name ИмяПодмодуля)
//
Процедура ДобавитьПодмодуль(Знач АдресВнешнегоРепозитория, 
    Знач Местоположение = "",
    Знач Ветка = "",
    Знач ИмяПодмодуля = "") Экспорт
    
    ПараметрыЗапуска = Новый Массив;
    ПараметрыЗапуска.Добавить("submodule");
    ПараметрыЗапуска.Добавить("add");
    
    Если ЗначениеЗаполнено(Ветка) Тогда
        ПараметрыЗапуска.Добавить("-b");
        ПараметрыЗапуска.Добавить(Ветка);
    КонецЕсли;
    
    Если ЗначениеЗаполнено(ИмяПодмодуля) Тогда
        ПараметрыЗапуска.Добавить("--name");
        ПараметрыЗапуска.Добавить(ИмяПодмодуля);
    КонецЕсли;
    
    ПараметрыЗапуска.Добавить(АдресВнешнегоРепозитория);
    
    Если ЗначениеЗаполнено(Местоположение) Тогда
        ПараметрыЗапуска.Добавить(Местоположение);
    КонецЕсли;
    
    ВыполнитьКоманду(ПараметрыЗапуска);
    
КонецПроцедуры

// Обновить данные о зарегистрированных подмодулях
// git submodule update
//
// Параметры:
//   Инициализировать - Булево - Выполнять инициализацию подмодуля (--init)
//   Рекурсивно - Рекурсивно - Обновлять подмодули подмодулей (--recursive)
//
Процедура ОбновитьПодмодули(Знач Инициализировать = Ложь, Знач Рекурсивно = Ложь) Экспорт
    
    ПараметрыЗапуска = Новый Массив;
    ПараметрыЗапуска.Добавить("submodule");
    ПараметрыЗапуска.Добавить("update");
    
    Если Инициализировать Тогда
        ПараметрыЗапуска.Добавить("--init");
    КонецЕсли;
    
    Если Рекурсивно Тогда
        ПараметрыЗапуска.Добавить("--recursive");
    КонецЕсли;
    
    ВыполнитьКоманду(ПараметрыЗапуска);
    
КонецПроцедуры

// Получить состояние подмодулей
//
//  Возвращаемое значение:
//   ТаблицаЗначений - Таблица с информацией о подмодулях.
//		Содержит колонки:
//			ХэшКоммита - Строка - Хэш коммита, на который указывает подмодуль
//			Имя - Строка - Имя подмодуля
//			Указатель - Строка - указатель на внешний репозиторий
//
Функция ПолучитьСостояниеПодмодулей() Экспорт
    
    ПараметрыЗапуска = Новый Массив;
    ПараметрыЗапуска.Добавить("submodule");
    ПараметрыЗапуска.Добавить("status");
    
    ВыполнитьКоманду(ПараметрыЗапуска);
    
    ВыводКоманды = ПолучитьВыводКоманды();
    
    ТаблицаПодмодулей = Новый ТаблицаЗначений;
    ТаблицаПодмодулей.Колонки.Добавить("ХэшКоммита");
    ТаблицаПодмодулей.Колонки.Добавить("Имя");
    ТаблицаПодмодулей.Колонки.Добавить("Указатель");
    
    ЧислоСтрок = СтрЧислоСтрок(ВыводКоманды);
    
    Для сч = 1 По ЧислоСтрок Цикл
        
        ДанныеПодмодуля = ТаблицаПодмодулей.Добавить();
        
        Строка = СтрПолучитьСтроку(ВыводКоманды, сч);
        Если ПустаяСтрока(Строка) Тогда
            Продолжить;
        КонецЕсли;
        
        ДанныеСтроки = СтрРазделить(Строка, " ");
        ДанныеПодмодуля.ХэшКоммита 	= ДанныеСтроки[0];
        ДанныеПодмодуля.Имя 		= ДанныеСтроки[1];
        ДанныеПодмодуля.Указатель 	= Сред(ДанныеСтроки[2], 2, СтрДлина(ДанныеСтроки[2]) - 2);
        
    КонецЦикла;
    
    Возврат ТаблицаПодмодулей;
    
КонецФункции

// Работа с подмодулями
//////////////////////////////////////////////

//////////////////////////////////////////////
// Работа с настройками git

// Получить значение настройки git
//
// Параметры:
//   ИмяНастройки - Строка - Имя настройки
//   РежимУстановкиНастроекGit - РежимУстановкиНастроекGit - Режим установки настройки.
//		Значения параметра содержатся в перечислении РежимУстановкиНастроекGit
//
//  Возвращаемое значение:
//   Строка - Значение настройки
//
Функция ПолучитьНастройку(Знач ИмяНастройки, Знач РежимУстановкиНастроекGit = Неопределено) Экспорт
    
    ПараметрыЗапуска = Новый Массив;
    ПараметрыЗапуска.Добавить("config");    
    ПараметрыЗапуска.Добавить(ИмяНастройки);
    

    Если РежимУстановкиНастроекGit <> Неопределено Тогда
        ПараметрыЗапуска.Добавить(РежимУстановкиНастроекGit);
    КонецЕсли;
    

    ВыполнитьКоманду(ПараметрыЗапуска);
    
    ВыводКоманды = СокрЛП(ПолучитьВыводКоманды());
    
    Возврат ВыводКоманды;
    
КонецФункции

// Установить настройку git
// git config
//
// Параметры:
//   ИмяНастройки - Строка - Имя настройки
//   ЗначениеНастройки - Строка - Устанавливаемое значение
//   РежимУстановкиНастроекGit - РежимУстановкиНастроекGit - Режим установки настройки.
//		Значения параметра содержатся в перечислении РежимУстановкиНастроекGit
//
Процедура УстановитьНастройку(Знач ИмяНастройки, Знач ЗначениеНастройки, Знач РежимУстановкиНастроекGit = Неопределено) Экспорт
    
    ПараметрыЗапуска = Новый Массив;
    ПараметрыЗапуска.Добавить("config");
    
	Если Найти(ЗначениеНастройки, " ") > 0 Тогда
		ЗначениеНастройки = ОбернутьВКавычки(ЗначениеНастройки);
	КонецЕсли;

    Если РежимУстановкиНастроекGit <> Неопределено Тогда
        ПараметрыЗапуска.Добавить(РежимУстановкиНастроекGit);
    КонецЕсли;
    
    ПараметрыЗапуска.Добавить(ИмяНастройки);
    ПараметрыЗапуска.Добавить(ЗначениеНастройки);
    
    ВыполнитьКоманду(ПараметрыЗапуска);
    
КонецПроцедуры

// Удаление секции настроек git
//
// Параметры:
//   ИмяСекции - Строка - Имя секции
//   РежимУстановкиНастроекGit - РежимУстановкиНастроекGit - Режим установки настройки.
//
Процедура УдалитьСекциюНастроек(Знач ИмяСекции, Знач РежимУстановкиНастроекGit = Неопределено) Экспорт
    
    ПараметрыЗапуска = Новый Массив;
    ПараметрыЗапуска.Добавить("config");
   
    Если РежимУстановкиНастроекGit <> Неопределено Тогда
        ПараметрыЗапуска.Добавить(РежимУстановкиНастроекGit);
    КонецЕсли;
    
    ПараметрыЗапуска.Добавить("--remove-section");
    ПараметрыЗапуска.Добавить(ИмяСекции);
    
    ВыполнитьКоманду(ПараметрыЗапуска);
    
КонецПроцедуры 


// Получить список настроек git
//
// Параметры:
//   РежимУстановкиНастроекGit - РежимУстановкиНастроекGit - Уровень, на котором
//		необходимо искать значения настроек
//
//  Возвращаемое значение:
//   Соответствие - Список настроек.
//		Ключ соответствия - ключ настройки
//		Значение соответствия - значение настройки
//
Функция ПолучитьСписокНастроек(Знач РежимУстановкиНастроекGit = Неопределено) Экспорт
    
    ПараметрыЗапуска = Новый Массив;
    ПараметрыЗапуска.Добавить("config");
    ПараметрыЗапуска.Добавить("--list");
    
    Если РежимУстановкиНастроекGit <> Неопределено Тогда
        ПараметрыЗапуска.Добавить(РежимУстановкиНастроекGit);
    КонецЕсли;
    
    ВыполнитьКоманду(ПараметрыЗапуска);
    
    ВыводКоманды = ПолучитьВыводКоманды();
    
    СписокНастроек = Новый Соответствие();
    
    ЧислоСтрок = СтрЧислоСтрок(ВыводКоманды);
    
    Для сч = 1 По ЧислоСтрок Цикл
        
        Строка = СтрПолучитьСтроку(ВыводКоманды, сч);
        СимволРавно = СтрНайти(Строка, "=");
        
        ИмяНастройки = Лев(Строка, СимволРавно - 1);
        ЗначениеНастройки = Прав(Строка, СтрДлина(Строка) - СимволРавно);
        
        СписокНастроек.Вставить(ИмяНастройки, ЗначениеНастройки);
        
    КонецЦикла;
    
    Возврат СписокНастроек;
    
КонецФункции

// Работа с настройками git
//////////////////////////////////////////////

// Выполнение произвольной команды git
//
// Параметры:
//   Параметры - Массив - Массив строковых аргументов, передаваемых в командную
//		строку. Добавляются после исполняемого файла.
//
Процедура ВыполнитьКоманду(Знач Параметры) Экспорт
    
    //NOTICE: https://github.com/oscript-library/v8runner 
    //Apache 2.0 
    ПроверитьВозможностьВыполненияКоманды();

    Команда = Новый Команда;

    Команда.УстановитьКоманду(ПолучитьПутьКГит());
    Команда.УстановитьРабочийКаталог(ПолучитьРабочийКаталог());
    Команда.УстановитьКодировкуВывода(КодировкаТекста.UTF8);
    
    Команда.ДобавитьПараметры(Параметры);
  
    КодВозврата = Команда.Исполнить();
    
    УстановитьВывод(СокрЛП(Команда.ПолучитьВывод()));
 
    Если КодВозврата <> 0 Тогда
        Лог.Ошибка("Получен ненулевой код возврата " + КодВозврата + ". Выполнение скрипта остановлено!");
        ВызватьИсключение ПолучитьВыводКоманды();
    Иначе
        Лог.Отладка("Код возврата равен 0");
    КонецЕсли;
    
КонецПроцедуры

//////////////////////////////////////////////////////////////////////////
// Работа со свойствами класса

// Получить текущий рабочий каталог.
//
//  Возвращаемое значение:
//   Строка - Путь к рабочему каталогу
//
Функция ПолучитьРабочийКаталог() Экспорт
    Возврат РабочийКаталог;
КонецФункции

// Установить текущий рабочий каталог.
// Все команды git будут выполняться относительно указанного каталога.
//
// Параметры:
//   ПутьРабочийКаталог - Строка - Путь к рабочему каталогу.
//		Может быть относительным.
//
Процедура УстановитьРабочийКаталог(Знач ПутьРабочийКаталог) Экспорт
    
    Файл_РабочийКаталог = Новый Файл(ПутьРабочийКаталог);
    Ожидаем.Что(
		Файл_РабочийКаталог.Существует(),
		СтрШаблон("Рабочий каталог <%1> не существует.", ПутьРабочийКаталог)
	).ЭтоИстина();
    
    РабочийКаталог = Файл_РабочийКаталог.ПолноеИмя;
    
КонецПроцедуры

// Получить путь к исполняемому файлу git.
//
//  Возвращаемое значение:
//   Строка - Путь к исполняемому файлу.
//		По умолчанию содержит значение "git".
//
Функция ПолучитьПутьКГит() Экспорт
    Возврат ПутьКГит;
КонецФункции

// Установить путь к исполняемому файлу git.
//
// Параметры:
//   Путь - Строка - Путь к исполняемому файлу.
//
Процедура УстановитьПутьКГит(Знач Путь) Экспорт
    ПутьКГит = Путь;
КонецПроцедуры

// Получить вывод последней выполненной команды.
//
//  Возвращаемое значение:
//   Строка - Вывод команды
//
Функция ПолучитьВыводКоманды() Экспорт
    Возврат мВыводКоманды;
КонецФункции

// Установить вывод последней выполненной команды.
//
// Параметры:
//   Сообщение - Строка - Вывод команды
//
Процедура УстановитьВывод(Знач Сообщение)
    мВыводКоманды = Сообщение;
КонецПроцедуры

//////////////////////////////////////////////////////////////////////////
// Служебные процедуры и функции

// Проверяет возможность выполнить команду.
//
Процедура ПроверитьВозможностьВыполненияКоманды()
    
    Ожидаем.Что(ПолучитьРабочийКаталог(), "Рабочий каталог не установлен.").Заполнено();
    
    Лог.Отладка("РабочийКаталог: " + ПолучитьРабочийКаталог());
    
КонецПроцедуры

// Оборачивает переданную строку в кавычки, если она еще не обернута.
//
// Параметры:
//   Строка - Строка - Входящая строка
//
//  Возвращаемое значение:
//   Строка - Строка, обернутая в кавычки
//
Функция ОбернутьВКавычки(Знач Строка)
    
    //NOTICE: https://github.com/oscript-library/v8runner 
    //Apache 2.0 
    
    Если Лев(Строка, 1) = """" и Прав(Строка, 1) = """" Тогда
        Возврат Строка;
    Иначе
        Возврат """" + Строка + """";
    КонецЕсли;
    
КонецФункции

// Очищает установленные переменные системы
//
Процедура ОчиститьУстановленныеПеременныеГит()
    
    УстановитьДатуКоммита("");

КонецПроцедуры

// Устанавливает переменную системы GIT_COMMITTER_DATE
//
// Параметры:
//   Дата - Дата - Дата для установки даты коммитера, отличной от текущей даты
//
Процедура УстановитьДатуКоммита(Знач Дата)
     
    СистемнаяИнформация.УстановитьПеременнуюСреды("GIT_COMMITTER_DATE", Дата);

КонецПроцедуры // УстановитьПеременнуюСреды()

// Устанавливает коммитера комментария в дополнительную секцию локальной настройки репозитория
//
// Параметры:
//   Коммитер - Строка - представление коммитера комментария в формате: автор <email@com>
//   ТребуетсяВосстановлениеНастроек - Булево - устанавливается в истина для последующего восстановления
//
Процедура УстановитьКоммитера(Знач Коммитер, ТребуетсяВосстановлениеНастроек = Ложь)

    РегуляркаДляПочты =  Новый РегулярноеВыражение ("<([^>]+)>");
    КоллекцияСовпадений = РегуляркаДляПочты.НайтиСовпадения(Коммитер);

    Наименование = Лев(Коммитер, СтрНайти(Коммитер, "<") - 1);
    
    Ожидаем.Что(КоллекцияСовпадений.Количество()).Равно(1);
    
    Почта = КоллекцияСовпадений[0].Группы[1].Значение; // Должно быть только одно значение
    
    НастройкаНаименования = ПолучитьИмяНастройкиНаименованияПользователя();
    НастройкаПочты = ПолучитьИмяНастройкиПочтыПользователя();

    ТекущееНаименование = ПолучитьНастройку(НастройкаНаименования, РежимУстановкиНастроекGit.Локально);
    ТекущаяПочта = ПолучитьНастройку(НастройкаПочты, РежимУстановкиНастроекGit.Локально);

    // Сохранение в отдельную секцию "bak"

    ТребуетсяСохранениеВСекцию_bak = НЕ (ПустаяСтрока(ТекущееНаименование) И ПустаяСтрока(ТекущаяПочта));
    Если ТребуетсяСохранениеВСекцию_bak Тогда
        
        // Установка новых значений в секцию bak
        УстановитьНастройку("bak."+ НастройкаНаименования, ТекущееНаименование);
        УстановитьНастройку("bak."+ НастройкаПочты, ТекущаяПочта);

        ТребуетсяВосстановлениеНастроек = Истина;

    КонецЕсли;

    // Установим новые значения
    УстановитьНастройку(НастройкаНаименования, Наименование, РежимУстановкиНастроекGit.Локально);
    УстановитьНастройку(НастройкаПочты, Почта,  РежимУстановкиНастроекGit.Локально);

КонецПроцедуры

// Восстановление коммитера комментария из резервной секции
//
Процедура ВосстановитьКоммитера()

    НастройкаНаименования = ПолучитьИмяНастройкиНаименованияПользователя();
    НастройкаПочты = ПолучитьИмяНастройкиПочтыПользователя();

    ТекущееНаименование = ПолучитьНастройку(НастройкаНаименования, РежимУстановкиНастроекGit.Локально);
    ТекущаяПочта = ПолучитьНастройку(НастройкаПочты, РежимУстановкиНастроекGit.Локально);

    Наименование_bak = ПолучитьНастройку("bak."+ НастройкаНаименования, РежимУстановкиНастроекGit.Локально);
    Почта_bak = ПолучитьНастройку("bak."+ НастройкаПочты, РежимУстановкиНастроекGit.Локально);

    // Установим новые значения
    Если ТекущееНаименование <> Наименование_bak Тогда 
        УстановитьНастройку(НастройкаНаименования, Наименование_bak, РежимУстановкиНастроекGit.Локально); 
    КонецЕсли;

    Если ТекущаяПочта <> Почта_bak Тогда 
        УстановитьНастройку(НастройкаПочты, Почта_bak, РежимУстановкиНастроекGit.Локально); 
    КонецЕсли;

    УдалитьСекциюНастроек("bak.user", РежимУстановкиНастроекGit.Локально);

КонецПроцедуры

// Возвращает имя настройки Гит для имени пользователя
//
Функция ПолучитьИмяНастройкиНаименованияПользователя()
    Возврат "user.name";
КонецФункции // ПолучитьИмяНастройкиНаименования()

// Возвращает имя настройки Гит для почты пользователя
//
Функция ПолучитьИмяНастройкиПочтыПользователя()
    Возврат "user.email";
КонецФункции // ПолучитьИмяНастройкиПочты()

Процедура УстановитьНастройкуКоманды(знач ИмяКоманды, КлассНастройкаКоманды)
    
    НастройкиКоманд.Вставить(ИмяКоманды, КлассНастройкаКоманды);

КонецПроцедуры

// Инициализация работы библиотеки.
// Задает минимальные настройки.
//
Процедура Инициализация()
    
    Лог = Логирование.ПолучитьЛог("oscript.lib.gitrunner");
    СистемнаяИнформация = Новый СистемнаяИнформация;
    ЭтоWindows = Найти(НРег(СистемнаяИнформация.ВерсияОС), "windows") > 0;
    
    НастройкиКоманд = Новый Соответствие;
    УстановитьПутьКГит("git");

КонецПроцедуры

Инициализация();
