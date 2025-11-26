# Sopel Przeprowadzki i transport — Strona statyczna

To jest kompletna, gotowa do wdrożenia statyczna strona informacyjna o usługach przeprowadzkowych.

Pliki w tym folderze:
- `index.html` — strona główna z formularzem (konfiguracja Netlify Forms)
- `thank-you.html` — stronę przekierowania po wysłaniu formularza
- `netlify.toml` — opcjonalna konfiguracja Netlify

Jak opublikować (darmowe opcje):

1) Netlify (najprościej)
- Zarejestruj się na https://app.netlify.com/ (darmowe konto)
- W dashboardzie: "New site from Git" (połącz z GitHub) lub przeciągnij folder `site` do "Deploys" → "Drag and drop".
- Netlify automatycznie obsłuży statyczny hosting i (jeśli zostawisz `data-netlify="true"`) formularze Netlify.
- W Netlify możesz ustawić własną domenę lub użyć subdomeny netlify.app.

2) GitHub Pages
- Utwórz repozytorium (np. `sopel-przeprowadzki`) i wypchnij zawartość folderu `site` do gałęzi `gh-pages` lub `main` (zależnie od ustawień Pages).
- W ustawieniach repo: Pages → wybierz gałąź i folder `/ (root)` → zapisz. Strona będzie dostępna na `https://<twoj-uzytkownik>.github.io/<repo>`.
- Uwaga: Netlify Forms nie będzie działać na GitHub Pages — trzeba użyć innego backendu dla formularzy (np. Formspree, Getform) lub JS/XHR do API.

3) Vercel
- Zarejestruj się na https://vercel.com/ i "Import Project" z GitHub lub przeciągnij folder.
- Vercel oferuje darmowy hosting dla stron statycznych.

Dodatkowe wskazówki:
- Skopiuj lokalne obrazy (np. `samochód.png`, `winda.png`, `Zdjęcie w windzie.png`) do tego folderu, albo zastąp nazwami plików w `index.html`.
- Jeśli chcesz własną domenę, skonfiguruj DNS u rejestratora i podłącz do Netlify/Vercel (instrukcje w panelu).
- Jeśli chcesz, mogę wygenerować gotowy plik `CNAME`, automatyczny workflow GitHub Actions (push -> Pages) lub plik `robots.txt`/`sitemap.xml`.
I added helper scripts in `scripts/`:
- `optimize_images.ps1` — tries to convert PNG/JPG images in `images/` to WebP using ImageMagick (`magick`) or `cwebp` if available.
- `deploy_github.ps1` — initializes git and (if `gh` CLI is installed) creates and pushes a GitHub repo for you.
- `deploy_netlify.ps1` — uses the Netlify CLI (`netlify`/`ntl`) to deploy the site if installed locally.

I also added `robots.txt` and `sitemap.xml`. NOTE: replace `https://example.com` in those files with your real domain before publishing.

Quick usage notes:

- To attempt WebP optimization (will only run if ImageMagick or cwebp is installed):

	```powershell
	cd scripts
	.\optimize_images.ps1
	```

- To create a GitHub repo and push (requires `git` and optional `gh`):

	```powershell
	cd ..\
	.\scripts\deploy_github.ps1 -RepoName "sopel-przeprowadzki-site"
	```

- To deploy to Netlify via CLI (requires `netlify-cli`):

	```powershell
	cd ..\
	.\scripts\deploy_netlify.ps1
	```

If you want, I can also:
- create a `CNAME` for a custom domain
- create a GitHub repo for you (requires your confirmation and auth on your side)

Powiedz, którą opcję preferujesz lub "zrób wszystko" i przygotuję dalsze kroki.
