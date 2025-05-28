import { Turbo } from "@hotwired/turbo-rails";
import { Application, Controller } from "@hotwired/stimulus";

// Setup Stimulus
const application = Application.start();

// EngagementModalController inline
class EngagementModalController extends Controller {
    static targets = ["notice"];

    open(event) {
        const selected = Array.from(document.querySelectorAll("input[type=checkbox]:checked"));
        if (selected.length === 0) {
            this.showNotice("Please select at least one profile.");
            return;
        }

        const ids = selected.map(cb => cb.value);
        const frame = document.getElementById("engagement_modal");

        fetch(`/profiles/engagement_modal?ids=${ids.join(",")}`, {
            headers: { "Turbo-Frame": "engagement_modal", Accept: "text/html" }
        })
            .then(res => res.text())
            .then(html => {
                frame.innerHTML = html;
            })
            .catch(err => {
                console.error("Fetch failed", err);
            });
    }

    showNotice(message) {
        if (!this.hasNoticeTarget) return;

        this.noticeTarget.innerText = message;
        this.noticeTarget.classList.remove("hidden");

        setTimeout(() => {
            this.noticeTarget.classList.add("hidden");
        }, 3000);
    }

    close(event) {
        const frame = document.getElementById("engagement_modal");
        if (frame) frame.innerHTML = "";
    }

    stopPropagation(event) {
        event.stopPropagation();
    }
}

application.register("engagement_modal", EngagementModalController);
