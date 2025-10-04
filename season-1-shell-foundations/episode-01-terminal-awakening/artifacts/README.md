# Artifacts — Episode 01: Terminal Awakening

## Тестовая среда

Папка `test_environment/` содержит файлы для отработки навыков поиска.

### Структура:

```
test_environment/
├── documents/
│   ├── briefing.txt           # Основной briefing от Viktor
│   └── .secret_location       # Скрытый файл с координатами
└── .next_server               # Скрытый файл с IP адресом
```

### Как использовать:

#### 1. Скопируйте test_environment в свою домашнюю папку:

```bash
cp -r artifacts/test_environment ~/
cd ~/test_environment
```

#### 2. Практикуйтесь в поиске файлов:

```bash
# Где я?
pwd

# Что здесь?
ls

# Есть ли скрытые файлы?
ls -a

# Что в подпапках?
ls -la documents/

# Найти briefing.txt
find . -name "briefing.txt"

# Найти все скрытые файлы
find . -name ".*" -type f

# Прочитать файл
cat documents/briefing.txt
cat documents/.secret_location
cat .next_server
```

#### 3. Создайте свой скрипт:

```bash
# Скопируйте starter.sh в test_environment
cp starter.sh ~/test_environment/find_files.sh

# Сделайте исполняемым
chmod +x ~/test_environment/find_files.sh

# Редактируйте и тестируйте
nano ~/test_environment/find_files.sh
./find_files.sh
```

#### 4. Проверьте результат:

Если всё сделано правильно, вы найдёте:
- ✅ `briefing.txt` — briefing от Viktor
- ✅ `.secret_location` — координаты 55.7558°N, 37.6173°E (Красная площадь)
- ✅ `.next_server` — IP 185.192.45.119 для Episode 02

---

## Дополнительные файлы (опционально)

Можете создать дополнительные файлы для практики:

```bash
cd ~/test_environment

# Создать больше скрытых файлов
echo "Decoy file 1" > documents/.fake1
echo "Decoy file 2" > .fake2

# Создать вложенные папки
mkdir -p documents/archive/old
echo "Old briefing" > documents/archive/old/briefing_2024.txt

# Теперь ищите!
find . -name ".*"
find . -name "briefing*"
```

---

## Автотесты

См. `tests/test.sh` для проверки вашего решения.

```bash
cd tests/
./test.sh
```

---

## Сброс среды

Если что-то сломалось:

```bash
rm -rf ~/test_environment
cp -r artifacts/test_environment ~/
```

---

**Удачи в поиске!** 🔍

