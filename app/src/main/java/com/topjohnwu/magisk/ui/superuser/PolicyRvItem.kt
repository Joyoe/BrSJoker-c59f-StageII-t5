package com.brightsight.joker.ui.superuser

import android.graphics.drawable.Drawable
import androidx.databinding.Bindable
import com.brightsight.joker.BR
import com.brightsight.joker.R
import com.brightsight.joker.core.model.su.JoJoPolicy
import com.brightsight.joker.databinding.ObservableItem
import com.brightsight.joker.utils.set

class PolicyRvItem(
    val item: JoJoPolicy,
    val icon: Drawable,
    val viewModel: SuperuserViewModel
) : ObservableItem<PolicyRvItem>() {
    override val layoutRes = R.layout.item_policy_md2

    @get:Bindable
    var isExpanded = false
        set(value) = set(value, field, { field = it }, BR.expanded)

    // This property hosts the policy state
    var policyState = item.policy == JoJoPolicy.ALLOW
        set(value) = set(value, field, { field = it }, BR.enabled)

    // This property binds with the UI state
    @get:Bindable
    var isEnabled
        get() = policyState
        set(value) = set(value, policyState, { viewModel.togglePolicy(this, it) }, BR.enabled)

    @get:Bindable
    var shouldNotify = item.notification
        set(value) = set(value, field, { field = it }, BR.shouldNotify) {
            viewModel.updatePolicy(updatedPolicy, isLogging = false)
        }

    @get:Bindable
    var shouldLog = item.logging
        set(value) = set(value, field, { field = it }, BR.shouldLog) {
            viewModel.updatePolicy(updatedPolicy, isLogging = true)
        }

    private val updatedPolicy
        get() = item.copy(
            policy = if (policyState) JoJoPolicy.ALLOW else JoJoPolicy.DENY,
            notification = shouldNotify,
            logging = shouldLog
        )

    fun toggleExpand() {
        isExpanded = !isExpanded
    }

    fun toggleNotify() {
        shouldNotify = !shouldNotify
    }

    fun toggleLog() {
        shouldLog = !shouldLog
    }

    fun revoke() {
        viewModel.deletePressed(this)
    }

    override fun contentSameAs(other: PolicyRvItem) = itemSameAs(other)
    override fun itemSameAs(other: PolicyRvItem) = item.uid == other.item.uid

}
