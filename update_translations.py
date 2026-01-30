#!/usr/bin/env python3
import json
import os

# Translations for all languages
translations = {
    "de": [
        "🧧 Mondneujahr kommt mit dem Frühling! Familientreffen und Wärme am Festtisch!",
        "🎊 Mögen alle Wünsche wahr werden, Wohlstand und Glück! Frohes Jahr des Pferdes!",
        "🌸 Der Frühling bringt Erneuerung, wir wünschen Gesundheit und Glück!",
        "🎆 Feuerwerkskörper platzen vor Freude, Familie feiert zusammen! Wohlstand im neuen Jahr!",
        "🍊 Obstplatte überquellend, Reichtum fließt reichlich! Wohlhabendes neues Jahr!",
        "🐴 Jahr des Pferdes galoppiert vorwärts, Karrierefortschritt und Familienharmonie!"
    ],
    "es": [
        "🧧 ¡El Año Nuevo Lunar llega con la primavera! ¡Reunión familiar y calidez en la mesa festiva!",
        "🎊 ¡Que todos los deseos se hagan realidad, prosperidad y fortuna! ¡Feliz Año del Caballo!",
        "🌸 La primavera trae renovación, ¡te deseo salud y felicidad siempre!",
        "🎆 ¡Los petardos estallan de alegría, la familia celebra junta! ¡Prosperidad en el año nuevo!",
        "🍊 ¡Bandeja de frutas desbordante, riqueza fluyendo abundantemente! ¡Próspero año nuevo!",
        "🐴 ¡El Año del Caballo galopa hacia adelante, avance profesional y armonía familiar!"
    ],
    "fr": [
        "🧧 Le Nouvel An Lunaire arrive avec le printemps ! Réunion de famille et chaleur autour de la table festive !",
        "🎊 Que tous les vœux se réalisent, prospérité et fortune ! Bonne Année du Cheval !",
        "🌸 Le printemps apporte le renouveau, vous souhaitant santé et bonheur toujours !",
        "🎆 Les pétards éclatent de joie, la famille célèbre ensemble ! Prospérité dans la nouvelle année !",
        "🍊 Plateau de fruits débordant, richesse affluant abondamment ! Prospère nouvelle année !",
        "🐴 L'Année du Cheval galope en avant, avancement de carrière et harmonie familiale !"
    ],
    "hi": [
        "🧧 चंद्र नववर्ष वसंत के साथ आता है! त्योहार की मेज के चारों ओर परिवार का पुनर्मिलन और गर्मजोशी!",
        "🎊 सभी इच्छाएं सच हों, समृद्धि और भाग्य! घोड़े का शुभ वर्ष!",
        "🌸 वसंत सभी चीजों में नवीनीकरण लाता है, आपको हमेशा स्वास्थ्य और खुशी की शुभकामनाएं!",
        "🎆 पटाखे खुशी से फटते हैं, परिवार एक साथ मनाता है! नए साल में समृद्धि!",
        "🍊 फलों की थाली भरी हुई, धन प्रचुर मात्रा में बह रहा है! समृद्ध नया साल!",
        "🐴 घोड़े का वर्ष आगे सरपट दौड़ता है, करियर में उन्नति और पारिवारिक सद्भाव!"
    ],
    "it": [
        "🧧 Il Capodanno Lunare arriva con la primavera! Riunione di famiglia e calore intorno al tavolo festivo!",
        "🎊 Possano tutti i desideri avverarsi, prosperità e fortuna! Buon Anno del Cavallo!",
        "🌸 La primavera porta rinnovamento, augurando salute e felicità sempre!",
        "🎆 I petardi scoppiano di gioia, la famiglia celebra insieme! Prosperità nel nuovo anno!",
        "🍊 Piatto di frutta traboccante, ricchezza che scorre abbondantemente! Prospero anno nuovo!",
        "🐴 L'Anno del Cavallo galoppa avanti, avanzamento di carriera e armonia familiare!"
    ],
    "ja": [
        "🧧 旧正月が春と共に訪れます！家族団らんと祝いの食卓を囲む温かさを!",
        "🎊 すべての願いが叶いますように、繁栄と幸運を！午年おめでとうございます！",
        "🌸 春がすべてに新しさをもたらします、健康と幸福を願っています！",
        "🎆 爆竹が喜びで爆発し、家族が一緒に祝います！新年の繁栄を！",
        "🍊 果物の盛り合わせが溢れ、富が豊かに流れ込みます！繁栄した新年を！",
        "🐴 午年が前進し、キャリアの向上と家族の調和を！"
    ],
    "ko": [
        "🧧 음력 설날이 봄과 함께 찾아옵니다! 명절 상 주위에서 가족 단합과 따뜻함을!",
        "🎊 모든 소원이 이루어지고 번영과 행운이 가득하길! 행복한 말의 해!",
        "🌸 봄은 모든 것에 새로움을 가져옵니다. 항상 건강하고 행복하시길!",
        "🎆 폭죽이 기쁨으로 터지고 가족이 함께 축하합니다! 새해 번영을!",
        "🍊 과일 접시가 넘치고 부가 풍부하게 흘러들어옵니다! 번영하는 새해를!",
        "🐴 말의 해가 앞으로 질주합니다. 경력 발전과 가족 화목을!"
    ],
    "pt": [
        "🧧 O Ano Novo Lunar chega com a primavera! Reunião familiar e calor em torno da mesa festiva!",
        "🎊 Que todos os desejos se tornem realidade, prosperidade e fortuna! Feliz Ano do Cavalo!",
        "🌸 A primavera traz renovação, desejando saúde e felicidade sempre!",
        "🎆 Fogos de artifício explodem de alegria, família celebra junta! Prosperidade no ano novo!",
        "🍊 Bandeja de frutas transbordando, riqueza fluindo abundantemente! Próspero ano novo!",
        "🐴 O Ano do Cavalo galopa adiante, avanço na carreira e harmonia familiar!"
    ],
    "ru": [
        "🧧 Лунный Новый год приходит с весной! Семейное воссоединение и тепло за праздничным столом!",
        "🎊 Пусть все желания сбудутся, процветание и удача! С годом Лошади!",
        "🌸 Весна приносит обновление, желаем здоровья и счастья всегда!",
        "🎆 Петарды взрываются от радости, семья празднует вместе! Процветание в новом году!",
        "🍊 Фруктовое блюдо переполнено, богатство течет обильно! Процветающий новый год!",
        "🐴 Год Лошади скачет вперед, карьерный рост и семейная гармония!"
    ],
    "th": [
        "🧧 ตรุษจีนมาพร้อมกับฤดูใบไม้ผลิ! การรวมตัวของครอบครัวและความอบอุ่นรอบโต๊ะเทศกาล!",
        "🎊 ขอให้ความปรารถนาทั้งหมดเป็นจริง ความเจริญรุ่งเรืองและโชคลาภ! สุขสันต์ปีมะเมีย!",
        "🌸 ฤดูใบไม้ผลินำมาซึ่งการฟื้นฟู ขออวยพรสุขภาพและความสุขตลอดไป!",
        "🎆 ประทัดระเบิดด้วยความยินดี ครอบครัวเฉลิมฉลองร่วมกัน! ความเจริญรุ่งเรืองในปีใหม่!",
        "🍊 จานผลไม้ล้นเหลือ ความมั่งคั่งไหลเข้ามาอย่างมากมาย! ปีใหม่ที่เจริญรุ่งเรือง!",
        "🐴 ปีมะเมียพุ่งไปข้างหน้า ความก้าวหน้าในอาชีพและความสามัคคีในครอบครัว!"
    ],
    "zh": [
        "🧧 春节到来春满园！祝家人团圆，围炉共享年夜饭！",
        "🎊 万事如意，恭喜发财！祝丙午马年吉祥如意！",
        "🌸 春回大地万物新，祝您健康快乐永相随！",
        "🎆 爆竹声声辞旧岁，合家欢乐迎新春！恭贺新禧！",
        "🍊 果盘满溢财源滚，祝您马年财运亨通！",
        "🐴 马年奔腾万里程，事业高升家和睦！"
    ]
}

# Process each language file
translations_dir = "assets/translations"

for lang_code, messages in translations.items():
    file_path = os.path.join(translations_dir, f"{lang_code}.json")
    
    try:
        # Read existing JSON
        with open(file_path, 'r', encoding='utf-8') as f:
            data = json.load(f)
        
        # Update new_year_messages
        data['new_year_messages'] = {
            str(i): msg for i, msg in enumerate(messages)
        }
        
        # Write back to file with proper formatting
        with open(file_path, 'w', encoding='utf-8') as f:
            json.dump(data, f, ensure_ascii=False, indent=2)
        
        print(f"✓ Updated {lang_code}.json")
    
    except Exception as e:
        print(f"✗ Error updating {lang_code}.json: {e}")

print("\n✓ All translations updated successfully!")
