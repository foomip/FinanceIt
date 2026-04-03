import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["cashPrice", "deposit", "amountToFinance", "totalAmountPayable", "apr"]

  connect() {
    this.amountToFinanceManualOverride = this.amountToFinanceTarget.value.trim() !== ""
    this.aprManualOverride = this.aprTarget.value.trim() !== ""

    if (!this.amountToFinanceManualOverride) {
      this.recalculate()
    }

    if (!this.aprManualOverride) {
      this.recalculateApr()
    }
  }

  recalculate() {
    if (this.amountToFinanceManualOverride) {
      return
    }

    const cashPrice = this.parseCurrency(this.cashPriceTarget.value)
    const deposit = this.parseCurrency(this.depositTarget.value)

    if (cashPrice === null || deposit === null) {
      this.amountToFinanceTarget.value = ""
      return
    }

    const amountToFinance = Math.max(cashPrice - deposit, 0)
    this.amountToFinanceTarget.value = amountToFinance.toFixed(2)
    this.recalculateApr()
  }

  markAmountToFinanceManualOverride() {
    const value = this.amountToFinanceTarget.value.trim()

    this.amountToFinanceManualOverride = value !== ""

    if (!this.amountToFinanceManualOverride) {
      this.recalculate()
      return
    }

    this.recalculateApr()
  }

  recalculateApr() {
    if (this.aprManualOverride) {
      return
    }

    const totalAmountPayable = this.parseCurrency(this.totalAmountPayableTarget.value)
    const amountToFinance = this.parseCurrency(this.amountToFinanceTarget.value)

    if (totalAmountPayable === null || amountToFinance === null || amountToFinance <= 0) {
      this.aprTarget.value = ""
      return
    }

    const apr = ((totalAmountPayable - amountToFinance) / amountToFinance) * 100
    this.aprTarget.value = Math.max(apr, 0).toFixed(2)
  }

  markAprManualOverride() {
    const value = this.aprTarget.value.trim()

    this.aprManualOverride = value !== ""

    if (!this.aprManualOverride) {
      this.recalculateApr()
    }
  }

  parseCurrency(value) {
    const normalizedValue = value.trim()

    if (normalizedValue === "") {
      return null
    }

    const parsedValue = Number.parseFloat(normalizedValue)

    return Number.isNaN(parsedValue) ? null : parsedValue
  }
}
