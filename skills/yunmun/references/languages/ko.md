# Korean calibration — 한국어 보정

Load whenever the target text is Korean, and apply it at the vocabulary and syntax scan that follows the ten checks of `professional-pass.md`, whether or not `style-pass.md` is loaded. It replaces the English-only lists in `style-pass.md` §2–4 and supplies the Korean forms of `professional-pass.md` checks 1, 2, 6, 7 and 10. It changes nothing else about the route. English ban lists do not transfer to Korean; what transfers is the *shape* of each check. Mixed Korean and English text is judged passage by passage.

Evidence, with file-local aliases:

- **K** = KatFishNet (Park et al., ACL 2025, arXiv:2503.00032). The KatFish benchmark: 470 human texts (181 student essays, 189 poems, 100 computer-science paper abstracts from 2016–2018) against 1,624 texts from GPT-4o, Solar, Qwen2 72B and Llama 3.1 70B. The only measured Korean human-vs-LLM source in this file.
- **N** = normative Korean references: 한글 맞춤법 부록 문장 부호 (2014 개정, 문화체육관광부 고시), 행정업무의 운영 및 혁신에 관한 규정 시행규칙의 공문서 표기, and the National Institute of Korean Language guide 「한눈에 알아보는 공공언어 바로 쓰기」. These are venue rules, not evidence about authorship.
- **F** = fluent-korean (snflkd, 2026, MIT, <https://github.com/snflkd/fluent-korean>): a practitioner guideline, written by a Korean-literature major, against the *compressed* failure of machine Korean. Editorial, not measured. Its ideas inform §2B and §3; no text is copied.
- **H** = editorial heuristics of this skill: tells that Korean editors and readers report, with no published human-vs-LLM measurement behind them. Every H row counts only in clusters.

## 0 Korean conventions (N; venue rules, not authorship signals)

A mismatch here is a register error to fix when the venue demands it. It never counts as evidence that a model wrote the text.

| Convention | Rule | How yunmun applies it |
|---|---|---|
| Date in official documents | `2026. 9. 19.` (periods, spaces, final period); weekday in parentheses `2026. 9. 19.(토)` | Fix only in 공문·보고서 venues. Prose venues may write `2026년 9월 19일` |
| Time | 24-hour `14:30` in official documents | Same gate |
| Money | `금113,560원(금일십일만삼천오백육십원)` in official documents; elsewhere `11만 3,560원` or `113,560원` | Never change the amount, only the notation |
| Quotation | Direct speech " ", quotation inside a quotation or emphasis ' ' | Do not swap a writer's consistent choice |
| Titles of works | 「 」『 』 or " " ' ' ; one system per document | Flag only mixed systems |
| Enumeration | 가운뎃점(·) for tightly bound items, comma for looser lists | Keep the writer's choice when consistent |
| Ellipsis and dash | 줄임표 may be `……` or `...`; the dash is rare in Korean prose | A dash in every paragraph is a §2 hit, a single dash is not |
| Sentence ending register | One of 합쇼체(-습니다), 해요체(-어요), 해라체(-다), or 개조식 noun endings per document | Mixed endings inside one section are a fluency finding. 개조식 form belongs to the `gaejosik` skill |
| Honorifics and titles | One way of naming each person or body across the document | Flag drift (교수님 / 교수 / 그) only when it confuses reference |
| Loanwords and abbreviations | Korean term first, abbreviation in parentheses at first use in public documents | Venue-gated to public and official text |

A workspace or organization style rule outranks every row above.

## 1 Measured (K)

| Feature | Human | LLM | Reading |
|---|---|---|---|
| Texts containing a comma | essay 26.31%, poem 27.01%, abstract 47.48% | 61.03%, 42.90%, 65.21% | LLMs put commas in far more texts |
| Comma share of tokens | 1.13%, 2.61%, 1.73% | 2.56%, 4.84%, 2.40% | Roughly double in essays and poems |
| Words between commas | 4.35, 1.96, 9.07 | 8.56, 2.13, 11.55 | LLM commas bound longer segments: they mark clause structure by rule |
| Spacing (띄어쓰기) | Omits spaces for stylistic and grammatical reasons | "Strictly follow spacing rules" | Perfect rule-conformant spacing is the LLM side; human looseness is the human side |
| Part-of-speech combinations | More diverse | Less diverse | The Korean form of templatedness |

Comma patterns were the strongest single feature family in K. This is why Korean differs from the English and Chinese entry in `style-pass.md` §7, which holds that no per-type punctuation count exists: for Korean, one does, within the limits in §6.

What follows from K, as inference of this skill: on review, a comma after nearly every connective adverb and between every pair of clauses is a candidate signal. On refactor, delete commas Korean does not need before adding anything. Never insert spacing errors or typos to look human: imperfection injection is its own fingerprint (`style-pass.md` §7).

## 2 What to hunt

Machine Korean fails at two opposite poles, and a text usually sits at one of them:

- **Padded (§2A):** long documents, reports, proposals, email. Filler, stacked connectives, translationese, hedged endings.
- **Compressed (§2B):** agent reports, chat answers, summaries, notes written under a brevity instruction. Dropped particles and endings, noun strings, omitted constituents, metaphor standing in for the plain word.

Decide the pole first. **Fixing one pole must not push the text to the other**: cutting filler must not strip particles, and restoring particles must not add filler. Slop is cumulative. One hit means nothing; clusters mean rewrite.

### 2A Padded pole

| # | Shape | Korean form | Fix | Class |
|---|---|---|---|---|
| 1 | Comma by rule | `또한, ` `따라서, ` `하지만, ` at every sentence start; a comma between every clause | Delete the comma; Korean connective endings already mark the boundary. The vocative and greeting comma (`안녕하세요, 김 팀장님.`) and commas inside lists are not this row | K |
| 2 | Connective stacking | Consecutive sentences or paragraphs opening with 또한 · 더불어 · 아울러 · 따라서 · 이처럼 · 이를 통해 · 나아가 | Delete most; order and juxtaposition carry the logic. One connective per paragraph is normal | H |
| 3 | Translationese postpositions | `~에 대한/대해` · `~를 통해` · `~로 인해` · `~에 있어서` · `~에 의해` · `~함에 있어` · `~의 경우` | Use the verb's own case marking: `정책에 대한 검토를 진행` → `정책을 검토` | N, H |
| 4 | `의` chains and noun stacking | `AI 기반의 교육 시스템의 개발의 필요성` | Drop `의`, turn a noun back into a verb, or split the phrase | N, H |
| 5 | Light-verb padding | `검토를 진행하다` · `분석을 수행하다` · `개선을 실시하다` · `논의를 가지다` | The plain verb: 검토하다 · 분석하다 · 개선하다 · 논의하다 | N, H |
| 6 | Passive and double passive | `되어지다` · `보여지다` · `~될 수 있을 것으로 보인다` · agentless `~된다` throughout | Name the actor and use the active verb; double passives are always wrong | N |
| 7 | Hedged endings on repeat | `~할 수 있다` · `~라고 할 수 있다` · `~것으로 보인다` · `~것이다` closing most sentences | Commit to the claim. Hedge once per genuinely uncertain claim (check 4) | H |
| 8 | Not-X-but-Y | `단순히 X가 아니라 Y이다` · `X를 넘어 Y로` · `X뿐만 아니라 Y도` | Say the one thing you mean | H |
| 9 | Rule of three | Three parallel nouns or clauses everywhere: `효율성, 투명성, 지속가능성` | Two or four, or name the one that matters | H |
| 10 | Inflation vocabulary | 혁신적인 · 획기적인 · 다양한 · 체계적인 · 효과적인 · 핵심적인 · 중요한 역할 · 새로운 패러다임 · 시너지 · 선도 · 고도화 · 극대화 | Replace with the fact the adjective stands in for, or delete | H |
| 11 | Signposting | `중요한 것은` · `핵심은` · `주목할 점은` · `결론적으로` · `요약하면` · `이러한 맥락에서` | Delete the signpost and let the sentence make the point | H |
| 12 | Chatbot residue (check 1) | `좋은 질문입니다` · `물론입니다` · `~해 드리겠습니다` · `도움이 되셨기를 바랍니다` · `추가로 궁금한 점이 있으시면` · `아래와 같이 정리해 보았습니다` | Delete | H |
| 13 | Empty framing (check 2) | `오늘날 급변하는 환경에서` · `4차 산업혁명 시대를 맞아` · `AI 시대에` · `~는 아무리 강조해도 지나치지 않다` | Start where the content starts | H |
| 14 | Conclusion residue (check 7) | `이상으로` · `앞으로도 지속적으로 노력하겠습니다` · `~할 것으로 기대된다` as the closing line of every section | End when the content ends. One expected-effect statement per document, with a number | H |
| 15 | Formatting tells (check 6) | Bold lead-in on every bullet, `소제목: 설명` colon headings, emoji headings, every section the same length, a closing 요약 that repeats the body | Prose where prose would do; vary depth by importance | H |
| 16 | Uniform sentence length | Runs of three or more adjacent sentences of about the same 어절 count | `style-pass.md` §5; count in 어절 consistently | measured in other languages, inference for Korean |
| 17 | Unsayable Korean (check 10) | Correct but never said: `해당 사항에 대한 확인이 필요한 상황입니다` | Speech-shaped: `이 부분은 확인이 필요합니다` | H |
| 18 | Pronoun calques | `그것은` · `이것은` · `그들은` · `우리는` as repeated subjects | Drop the subject or repeat the noun; Korean omits what is known | N, H |

Rows 3–6 are documented as faults in N long before LLMs existed, and human bureaucratic writing is full of them. They are quality findings first. They count toward an AI-tell cluster only together with rows that humans rarely produce (1, 2, 8, 11, 12).

### 2B Compressed pole (F)

The cost here is meaning, not style: the reader has to reconstruct what the writer skipped, and may reconstruct it wrongly. These rows apply to running prose. Headings, list items, table cells, 개조식 lines, code, commit messages and log strings keep their own conventions.

| # | Shape | Korean form | Fix | Class |
|---|---|---|---|---|
| 19 | Dropped particles and endings (전보체) | `설정 변경 후 서버 재시작 필요. 캐시 영향 없음 확인.` in a paragraph of prose | Restore particles, endings and auxiliaries: `설정을 변경한 뒤에는 서버를 다시 시작해야 합니다. 캐시에는 영향이 없다는 점도 확인했습니다.` | F |
| 20 | Sentence ending on a noun phrase or a connective ending | `이 방식은 비용이 낮은 편.` · `일정이 촉박해서.` | Close with a predicate and a final ending | F |
| 21 | Omitted constituent | `그러면 경고가 붙습니다` with no statement of where or to what; a subject or object the reader cannot recover | State it. Ellipsis is for what the reader already holds, not for what the writer finds obvious | F |
| 22 | `의` standing in for a predicate | `사본의 문구` · `작업의 상황` hiding `사본에 적힌` · `작업이 진행되는` | Put the verb back. The reverse of row 4: there `의` chains pad, here one `의` deletes meaning | F |
| 23 | Noun strings without relations | `지출 비용 추론 용도 토큰 계산 함수 오류 상황` | Apt Sino-Korean words joined by particles and endings: `지출한 비용을 추론하는 토큰 계산 함수에 오류가 발생하면` | F |
| 24 | Metaphor standing in for the plain word | `코드로 박다` · `기능을 얹다` · `규칙을 녹이다` · `정책이 갈리는 자리` · `논의의 결` · `짚고 넘어가다` on repeat | The literal verb or noun: 명시하다 · 추가하다 · 반영하다 · 달라지는 지점. Keep an idiom the field actually uses | F |
| 25 | Rare dictionary words | Correct but uncommon words where a common one exists | The word people use; rarity costs the reader time | F |
| 26 | Dash compressing the relation | `A — B` where the reader must guess whether B explains, contrasts or follows | A connective or a colon that names the relation | F |

Row 24 is also an author-voice question: blunt workshop verbs in one engineer's own notes are a habit, not a tell. Flag them in text meant for other readers.

## 3 What to restore — sprinkled, never poured

Restore to the degree the venue and the author's voice allow. Restoring is not padding: run the deletion and reversion tests (`professional-pass.md`, closing check 2) on everything you add.

| Restore | Korean form |
|---|---|
| Subject and topic ellipsis, within limits | Drop `저는` · `우리는` · `이것은` when the reader already holds the referent. Never drop a constituent that carries meaning (§2B row 21) |
| The apt word | The precise word for the context, native or Sino-Korean, joined by particles and endings. It beats both light-verb padding (`검토를 진행하다`) and a vague native verb that loses meaning (`쓴 비용` for `지출한 비용`) |
| Particles, endings, auxiliaries | On compressed text, restore 조사 · 어미 · 보조 용언 · 보조사 until every relation is stated. This is repair, not padding |
| Sentence-length spread | One short sentence among long ones, or the reverse; move words, never add them |
| Ending variety within one register | In 해라체 prose: `-다` · `-ㄴ다` · a question · a noun-ending fragment. Not a mix of registers |
| Plain causal links | `~해서` · `~니까` · `그래서` in place of `~로 인해` · `~함에 따라` |
| Concrete particulars | The name, the number with its unit and date, the actual file or clause. Only if real |
| Fewer commas | Let connective endings do the work |
| Register-true bluntness | `안 됩니다` · `틀렸습니다` where a judgment is required |

## 4 Reported tells that do not stand alone

| Reported tell | What it actually is | Treatment |
|---|---|---|
| Frequent `~습니다` formality | Register, set by venue | Not a tell. Check only register drift |
| Em dash or colon in a sentence | Release-specific habit (`model-fingerprints.md`) and rare in Korean | Counts only in clusters |
| English terms in parentheses after every noun | Translation habit, common in human technical writing too | Keep at first use, delete repeats |
| Bullet lists | Conventional in Korean business documents | Flag only bold-lead-in bullets replacing an argument |
| Perfect spelling and spacing | Proofread human text looks the same | Not a tell on edited or published text; K measured unedited student and poetry text |

## 5 Not signals in Korean

Do not flag these, and do not "fix" them:

- Uniform line length, noun endings, `항목: 내용` colon labels and parallel item phrasing in 개조식 documents. That form is prescribed, and it belongs to `gaejosik`. §2 row 15 and professional-pass check 8 do not apply inside it.
- Fixed official-document phrases: `귀 기관의 무궁한 발전을 기원합니다` · `붙임` · `끝.` · `~하고자 합니다`. Venue convention.
- A high share of Sino-Korean vocabulary in academic, legal or administrative text.
- The honorific level itself, or the absence of colloquial endings in formal text.
- Paragraph count or average paragraph length (`style-pass.md` §7).
- The author's own verified habits.

## 6 Evidence boundary

K covers three genres only (student essays, poetry, computer-science abstracts), compares fully human with fully generated text, and tested four models from 2024. It did not measure business documents, news, email, edited text, or human-edited machine text, and its human side is mostly student and amateur writing, so its comma and spacing gaps are likely larger than they would be against professional writers. No row in this file licenses a per-passage cutoff or a verdict that a text is machine-written. Every F row is a practitioner guideline and every H row is an editorial heuristic; neither has a published human-vs-LLM measurement behind it, and §2B describes a failure of clarity that human note-takers also produce; treat a future measurement as superior to it.
