<script>
import badges from '../../data/badges'

export default {
  data () {
    return {
      badges: badges,
      months: {}
    }
  },

  methods: {
    getBadgeIcon (badge, score) {
      return (score < badge.points) ? badge.smallIcon.unchecked : badge.smallIcon.checked;
    }
  },

  mounted() {
    chrome.storage.local.get("months", function (data) {
      this.months = data.months;
    }.bind(this))
  }
}
</script>

<template>
  <p class="fr-text--sm fr-mt-5v fr-mb-2v">Mon historique</p>

  <div class="fr-card fr-card--horizontal fr-mb-2v" v-for="month in Object.values(months).reverse()">
    <div class="fr-card__body fr-py-2v fr-px-2w">
      <div class="fr-grid-row">
        <div class="fr-col-5">
          <h3 class="fr-card__title fr-h4 fr-mb-1v">{{ month.label.month }}</h3>
          <p class="fr-text--lg fr-mb-0">{{ month.label.year }}</p>
        </div>
        <div class="fr-col">
          <p class="fr-text--sm fr-mb-1v">Score du mois</p>
          <p class="score fr-mb-0">{{ month.score }}</p>
        </div>
        <div class="fr-col">
          <p class="fr-text--sm fr-mb-3v">Badges obtenus</p>
          <div>
            <img class="img-badge fr-mr-1v" :src="getBadgeIcon(badge, month.score)" alt="Badge {{ badge.label }}" v-for="badge in badges" />
          </div>
        </div>
        <div class="fr-col">
          <p class="fr-text--sm fr-mb-1v">Alertes du mois</p>
          <div class="alerts">
            <div :class="{ 'is-inactive': month.alerts.orange === 0 }" class="fr-alert fr-alert--warning">
              <p>{{ month.alerts.orange }}</p>
            </div>
            <div :class="{ 'is-inactive': month.alerts.red === 0 }" class="fr-alert fr-alert--error">
              <p>{{ month.alerts.red }}</p>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<style scoped>
.fr-card {
  border-radius: 6px;
}

.fr-display-xs {
  font-size: 3rem !important;
  line-height: 3.5rem !important;
}

.score {
  font-size: 2.5rem !important;
  line-height: 2.5rem !important;
}
.alerts {
  display: flex;
}

.fr-alert {
  margin-right: 0.5rem;
  margin-top: 0;
  padding-right: 1.25rem;
  padding-top: 0.45rem;
  padding-bottom: 0.45rem;
}
.fr-alert::before {
  margin: 0.45rem 0.5rem;
}

.img-badge {
  max-width: 20%;
  height: 32px;
}
</style>
